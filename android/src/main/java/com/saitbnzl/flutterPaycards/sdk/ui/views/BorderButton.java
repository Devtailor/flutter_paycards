package com.saitbnzl.flutterPaycards.sdk.ui.views;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import androidx.appcompat.widget.AppCompatButton;

import android.graphics.RectF;
import android.util.AttributeSet;

public class BorderButton extends AppCompatButton {

    private Paint borderPaint;
    private float padding;

    public BorderButton(Context context) {
        super(context);
        init();
    }

    public BorderButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public BorderButton(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {
        // Padding is needed to avoid drawing out of canvas
        padding = getResources().getDisplayMetrics().density / 1.5f;
        borderPaint = new Paint();
        borderPaint.setStrokeWidth(padding);
        borderPaint.setStyle(Paint.Style.STROKE);
        borderPaint.setAntiAlias(true);
        borderPaint.setColor(0xFFDEDEDE);
    }

    @SuppressLint("NewApi")
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        RectF borderRect = new RectF(padding, padding, (float) getWidth() - padding, (float) getHeight() - 2 * padding);
        canvas.drawRoundRect(borderRect, 3 * getHeight(), 3 * getHeight(), borderPaint);
    }
}
