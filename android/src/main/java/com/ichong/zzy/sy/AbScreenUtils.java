package com.ichong.zzy.sy;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Toast;

public class AbScreenUtils {
    /**
     * 获得屏幕宽度
     *
     * @param context
     * @return
     */
    public static int getScreenWidth(Context context) {
        WindowManager wm = (WindowManager) context
                .getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics.widthPixels;
    }

    public static int getScreenWidth(Context context,boolean isDp){
        int screenWidth = 0;
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics dm = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(dm);
        int width = dm.widthPixels;       // 屏幕高度（像素）

        if(!isDp){
            return width;
        }

        float density = dm.density;         // 屏幕密度（0.75 / 1.0 / 1.5）
        screenWidth = (int) (width / density);// 屏幕高度(dp)
        return screenWidth;
    }

    /**
     * 设置控件的宽高
     *
     * @param view
     * @param widthPixels
     * @param heightPixels
     */
    public static void setViewWH(View view, int widthPixels, int heightPixels) {
        ViewGroup.LayoutParams params = view.getLayoutParams();
        if (params == null) {
//			AbLogUtil.e(AbViewUtil.class,
//					"setViewSize出错,如果是代码new出来的View，需要设置一个适合的LayoutParams");
            return;
        }
        params.width = widthPixels;
        params.height = heightPixels;
        view.setLayoutParams(params);
        view.requestLayout();
    }

    /**
     * 设置状态栏颜色
     * @param activity
     */
    public static void setWindowDecor(Activity activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = activity.getWindow();
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            //window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
            window.setStatusBarColor(Color.TRANSPARENT);
        }
    }

    /**
     * dp转换成px
     */
    public static int dp2px(Context context,float dpValue){
        float scale=context.getResources().getDisplayMetrics().density;
        return (int)(dpValue*scale+0.5f);
    }

    private static Handler mainHandler;
    public static void showToast(final Context context, final String msg){
        mainHandler = new Handler(Looper.getMainLooper());
        execute(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();
            }
        });
    }
    private static void execute(Runnable runnable) {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            runnable.run();
        } else {
            mainHandler.post(runnable);
        }
    }
}
