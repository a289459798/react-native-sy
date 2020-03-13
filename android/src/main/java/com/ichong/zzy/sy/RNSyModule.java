
package com.ichong.zzy.sy;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.RelativeLayout;
import com.chuanglan.shanyan_sdk.OneKeyLoginManager;
import com.chuanglan.shanyan_sdk.listener.*;
import com.chuanglan.shanyan_sdk.tool.ShanYanUIConfig;
import com.facebook.react.bridge.*;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class RNSyModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNSyModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNSy";
    }

    @ReactMethod
    public void init(String appId, boolean debug, final Callback callback) {
        OneKeyLoginManager.getInstance().setDebug(debug);
        OneKeyLoginManager.getInstance().init(reactContext, appId, new InitListener() {
            @Override
            public void getInitStatus(int i, String s) {
                Map map = getResult(i, s);
                callback.invoke(i, map.get("data"));
            }
        });
    }


    @ReactMethod
    public void preGetPhonenumber(final Callback callback) {
        OneKeyLoginManager.getInstance().getPhoneInfo(new GetPhoneInfoListener() {
            @Override
            public void getPhoneInfoStatus(int code, String result) {
                System.out.println("result:" + result);
                Map map = getResult(code, result);
                callback.invoke(code, map.get("data"));
            }
        });
    }

    @ReactMethod
    public void login(final ReadableMap style, final Callback callback) {

        OneKeyLoginManager.getInstance().setAuthThemeConfig(getConfig(style, callback));
        OneKeyLoginManager.getInstance().openLoginAuth(true, new OpenLoginAuthListener() {
            @Override
            public void getOpenLoginAuthStatus(int code, String result) {
                if (code != 1000) {
                    Map map = getResult(code, result);
                    callback.invoke(code, map.get("data"));
                }
            }
        }, new OneKeyLoginListener() {
            @Override
            public void getOneKeyLoginStatus(int code, String result) {
                Map map = getResult(code, result);
                callback.invoke(code, map.get("data"));
            }
        });
    }

    private ShanYanUIConfig getConfig(final ReadableMap style, final Callback callback) {
        //loading自定义加载框
        LayoutInflater inflater = LayoutInflater.from(getCurrentActivity());
        RelativeLayout view_dialog = (RelativeLayout) inflater.inflate(R.layout.custom_loading_dialog, null);
        RelativeLayout.LayoutParams mLayoutParams3 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
        view_dialog.setLayoutParams(mLayoutParams3);
        view_dialog.setVisibility(View.GONE);

        Button close = new Button(reactContext);
        close.setBackgroundResource(R.drawable.close_black);
        RelativeLayout.LayoutParams mLayoutParamsClose = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        mLayoutParamsClose.setMargins(0, AbScreenUtils.dp2px(reactContext, 10), AbScreenUtils.dp2px(reactContext, 10), 0);
        mLayoutParamsClose.width = AbScreenUtils.dp2px(reactContext, 15);
        mLayoutParamsClose.height = AbScreenUtils.dp2px(reactContext, 15);
        mLayoutParamsClose.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        close.setLayoutParams(mLayoutParamsClose);


        /****************************************************设置授权页*********************************************************/

        int id = reactContext.getResources().getIdentifier("ic_launcher", "mipmap", reactContext.getPackageName());

        Drawable authNavHidden = reactContext.getResources().getDrawable(R.drawable.sysdk_login_bg);
        Drawable navReturnImgPath = reactContext.getResources().getDrawable(R.drawable.sy_sdk_left);
        Drawable logoImgPath = reactContext.getResources().getDrawable(id);

        Drawable logBtnImgPath = reactContext.getResources().getDrawable(R.drawable.login_btn_bg);
        Drawable uncheckedImgPath = reactContext.getResources().getDrawable(R.drawable.umcsdk_uncheck_image);
        Drawable checkedImgPath = reactContext.getResources().getDrawable(R.drawable.umcsdk_check_image);

        ShanYanUIConfig uiConfig = new ShanYanUIConfig.Builder()
            .setDialogTheme(true, AbScreenUtils.getScreenWidth(reactContext, true) - 66, 400, 0, 0, false)

            //授权页导航栏：
            .setNavColor(Color.parseColor("#ffffff"))  //设置导航栏颜色
            .setNavText("")  //设置导航栏标题文字
            .setNavTextColor(0xff080808) //设置标题栏文字颜色
            .setNavReturnImgPath(navReturnImgPath)  //
            .setNavReturnImgHidden(false)
            .setAuthNavHidden(true)
            .setAuthBGImgPath(authNavHidden)

            //授权页logo（logo的层级在次底层，仅次于自定义控件）
            .setLogoImgPath(logoImgPath)  //设置logo图片
            .setLogoWidth(108)   //设置logo宽度
            .setLogoHeight(45)   //设置logo高度
            .setLogoOffsetY(65)  //设置logo相对于标题栏下边缘y偏移
            .setLogoHidden(false)   //是否隐藏logo

            //授权页号码栏：
            .setNumberColor(0xff3FA5F0)  //设置手机号码字体颜色
            .setNumFieldOffsetY(114)    //设置号码栏相对于标题栏下边缘y偏移
            .setNumberSize(18)

            //授权页登录按钮：
            .setLogBtnText("本机号码一键登录")  //设置登录按钮文字
            .setLogBtnTextColor(0xffffffff)   //设置登录按钮文字颜色
            .setLogBtnImgPath(logBtnImgPath)   //设置登录按钮图片
            .setLogBtnOffsetY(180)   //设置登录按钮相对于标题栏下边缘y偏移
            .setLogBtnTextSize(15)
            .setLogBtnWidth(250)
            .setLogBtnHeight(40)

            //授权页隐私栏：
            .setPrivacyOffsetBottomY(15)//设置隐私条款相对于屏幕下边缘y偏
            .setUncheckedImgPath(uncheckedImgPath)
            .setCheckedImgPath(checkedImgPath)
            .setPrivacyTextSize(12)


            //授权页slogan：
            .setSloganTextColor(0xff999999)  //设置slogan文字颜色
            .setSloganOffsetY(295)  //设置slogan相对于标题栏下边缘y偏移
            .setSloganTextSize(9)
            .setSloganHidden(true)
            // 添加自定义控件:
            .addCustomView(close, true, false, new ShanYanCustomInterface() {
                @Override
                public void onClick(Context context, View view) {
                    callback.invoke("500", "取消登录");
                }
            })
            .build();
        return uiConfig;
    }

    private Map<String, Object> getResult(int code, String res) {

        HashMap<String, Object> map = new HashMap<>();
        if (code == 1000 || code == 2000) {

            JsonObject obj = (JsonObject) new JsonParser().parse(res);
            Bundle bundle = new Bundle();
            Iterator iter = obj.entrySet().iterator();
            while (iter.hasNext()) {
                Map.Entry entry = (Map.Entry) iter.next();
                bundle.putString(entry.getKey().toString(), entry.getValue().toString().replace("\"", ""));
            }
            System.out.println("bundle:" + bundle.get("telecom"));
            WritableMap m = Arguments.fromBundle(bundle);
            map.put("data", m);
        } else {
            String error = "";
            switch (code) {
                case 1001:
                    error = "运营商通道关闭";
                    break;
                case 1002:
                    error = "运营商信息获取失败";
                    break;
                case 1003:
                    error = "一键登录获取token失败";
                    break;
                case 1007:
                    error = "网络请求失败";
                    break;
                case 1008:
                    error = "未开启网络";
                    break;
                case 1009:
                    error = "未检测到SIM卡";
                    break;
                case 1011:
                    error = "取消免密登录";
                    break;
                case 1014:
                    error = "SDK内部异常";
                    break;
                case 1016:
                    error = "APPID为空";
                    break;
                case 1017:
                    error = "APPKEY为空";
                    break;
                case 1019:
                    error = "其他错误";
                    break;
                case 1020:
                    error = "非三大运营商，无法使用一键登录功能";
                    break;
                case 1021:
                    error = "运营商信息获取失败（accessToken失效）";
                    break;
                case 1023:
                    error = "预初始化失败";
                    break;
                case 1025:
                    error = "非联通号段（目前联通号段 46001 46006 46009）";
                    break;
                case 1031:
                    error = "请求过于频繁";
                    break;
                case 2001:
                    error = "传入的手机号为空";
                    break;
                case 2003:
                    error = "本机号校验失败";
                    break;
                case 2020:
                    error = "非三大运营商";
                    break;
            }
            map.put("data", error);
        }

        return map;
    }
}