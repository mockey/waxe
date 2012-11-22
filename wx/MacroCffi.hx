package wx;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
using Lambda;
using StringTools;
#end

#if !macro @:autoBuild(wx.Cffi.addFuncs()) #end
interface MacroCffi {}


class Cffi {
	#if macro
	static var prefix:String;
	static var fields:Array<Field>;
	#end

	@:macro public static function addFuncs():Array<Field> {
		var pos = Context.currentPos();
		var meta = Context.getLocalClass().get().meta.get().filter(
			function(m) return m.name == ":wx"
		).first();
		if (meta == null)
			Context.error("missing @:wx(...) metadata", pos);
		if (meta.params.length != 1)
			Context.error("invalid @:wx(...) metadata", pos);
		prefix = "wx_" + getEString(meta.params[0]);
		fields = [];
		var flds = Context.getBuildFields();
		for (fld in flds) {
			if (fld.name == "create") {
				addCreateFunc(fld);
				continue;
			}
			var meta = fld.meta.filter(function(m) return m.name.startsWith(":wx_")).first();
			if (meta != null) {
				if (meta.params.length != 1)
					Context.error("invalid metadata: " + meta, pos);
				var m = meta.name.split("_").pop();
				switch (m) {
					case "func" :
						addFunc(fld, getEString(meta.params[0]));
					case "prop", "idx" :
						addPropFuncs(fld, getEString(meta.params[0]), m == "idx");
					case "event" :
						addEventFunc(fld, getEString(meta.params[0]));
					default : Context.error("invalid metadata: @:wx_" + m, pos);
				}
			}
		}
		flds = flds.concat(fields);
		return flds;
	}
	
	#if macro
	// add general CFFI function:
	static function addFunc(fld:Field, param:String) {
		var pos = Context.currentPos();
		param = "_" + param;
		var nargs = getArgCount(fld, param);
		if (nargs > 5) nargs = -1;
		var e = expr(ECall(
			identExpr("Loader.load"), 
			[expr(EConst(CString(prefix + param))), expr(EConst(CInt(Std.string(nargs))))]
		));
		fields.push({
			access: [APrivate, AStatic], name: param, 
			kind: FVar(stdType("Dynamic"), e),
			meta: [], pos: pos
		});
	}
	
	// add CFFI function for _create:
	static function addCreateFunc(fld:Field) {
		var pos = Context.currentPos();
		var nargs = 1;
		var targs = [stdType("Array", "Dynamic")];
		var added = getFunArgs(fld).filter(function(a)
			return !["inParent", "inID", "inValue", "inPosition", "inSize", "inStyle"].has(a.name)
		);
		// handle additional args:
		if (added.length > 0) {
			nargs += added.length;
			for (a in added) targs.push(a.type);
		}
		var e = expr(ECall(
			identExpr("Loader.load"), 
			[expr(EConst(CString(prefix + "_create"))), expr(EConst(CInt(Std.string(nargs))))]
		));
		fields.push({
			access: [APrivate, AStatic], name: "_create", 
			//kind: FVar(TFunction(targs, stdType("Void")), e),
			kind: FVar(null, e),
			meta: [], doc: null, pos: pos
		});
	}
	
	// turn var into property with getter/setter functions and CFFI functions:
	static function addPropFuncs(fld:Field, param:String, idx:Bool) {
		var pos = Context.currentPos();
		var t = getVarType(fld);
		fld.kind = FProp("get_" + fld.name, "set_" + fld.name, t);
		fld.meta.push({name: ":isVar", params: [], pos: pos});
		for (f in ["get", "set"]) {
			var fname = "_" + f + "_" + param;
			var nargs = f == "get" ? 1 : 2;
			if (idx) nargs++;
			var e = expr(ECall(
				identExpr("Loader.load"), 
				[expr(EConst(CString(prefix + fname))), expr(EConst(CInt(Std.string(nargs))))]
			));
			fields.push({
				access: [APrivate, AStatic], name: fname, kind: FVar(stdType("Dynamic"), e),
				meta: [], doc: null, pos: pos
			});
			var args = [], params = [identExpr("wxHandle")];
			if (idx) params.push(identExpr("index"));
			if (f == "get") {
				e = expr(EReturn(
					expr(ECall(identExpr(fname), params))
				));
			}
			else {
				args.push({name: "v", type: t, opt: false, value: null});
				params.push(identExpr("v"));
				e = expr(EBlock([
					expr(ECall(identExpr(fname), params)),
					expr(EReturn(assignExpr(identExpr(fld.name), identExpr("v"))))
				]));
			}
			var func = {args: args, expr: e, ret: t, params: []};
			fields.push({
				access: [APrivate], name: f + "_" + fld.name, kind: FFun(func),
				meta: [], doc: null, pos: pos
			});
		}
	}
	
	// add event property with setter:
	static function addEventFunc(fld:Field, param:String) {
		var pos = Context.currentPos();
		var t = getVarType(fld);
		fld.kind = FProp("null", "set_" + fld.name, t);
		var args = [{name: "f", type: t, opt: false, value: null}];
		var e = expr(EBlock([
			expr(ECall(identExpr("setHandler"), 
				[identExpr("wx.EventID." + param), identExpr("f")])),
			expr(EReturn(identExpr("f")))
		]));
		var func = {args: args, expr: e, ret: t, params: []};
		fields.push({
			access: [APrivate], name: "set_" + fld.name, kind: FFun(func),
			meta: [], doc: null, pos: pos
		});
	}
	
	static function expr(def:ExprDef, ?pos:Position):Expr {
		return {expr: def, pos: pos == null ? Context.currentPos() : pos};
	}
	
	static function identExpr(name:String):Expr {
		var arr = name.split("."), e = null;
		while (arr.length > 0)
			e == null ? e = expr(EConst(CIdent(arr.shift()))) : e = expr(EField(e, arr.shift()));
		return e;
	}
	
	static function assignExpr(e1:Expr, e2:Expr):Expr {
		return expr(EBinop(OpAssign, e1, e2));
	}
	
	static function stdType(name:String, ?t:String):ComplexType {
		var params = t != null ? [TPType(stdType(t))] : [];
		return TPath({pack: [], name: name, params: params, sub: null});
	}
	
	static function getEString(e:Expr):String {
		return switch (e.expr) {
			case EConst(c) :
				switch (c) {
					case CString(s), CIdent(s) : s;
					default : null;
				}
			default : null;
		}
	}
	
	static function getVarType(f:Field):ComplexType {
		return switch (f.kind) {
			case FVar(t, e) : return t;
			default : null;
		}
	}
	
	static function getFunArgs(f:Field):Array<FunctionArg> {
		return switch (f.kind) {
			case FFun(f) : return f.args;
			default : null;
		}
	}
	
	static function getArgCount(f:Field, name:String):Int {
		switch (f.kind) {
			case FFun(f) :
				switch (f.expr.expr) {
					case EBlock(exprs) :
						for (e in exprs) {
							switch (e.expr) {
								case ECall(e, params) :
									if (getEString(e) == name)
										return params.length;
								case EReturn(e) :
									switch (e.expr) {
										case ECall(e, params) :
											if (getEString(e) == name)
												return params.length;
										default :
									}
								default :
							}
						}
					default :
				}
			default :
		}
		return 0;
	}
	#end
}
