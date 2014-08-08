/*
 * CONFIDENTIAL
 * Copyright 2014 Webalo, Inc.  All rights reserved.
 */

package com.mahfouz.multic.android;

import android.animation.Animator;
import android.animation.Animator.AnimatorListener;
import android.animation.AnimatorListenerAdapter;
import android.animation.ArgbEvaluator;
import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;
import android.animation.ValueAnimator.AnimatorUpdateListener;
import android.content.Context;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.TextView;

import com.mahfouz.multic.R;
import com.mahfouz.multic.core.Player;
import com.mahfouz.multic.uim.XGameGridUiModel;

/**
 * Extension of Android GridView that displays square cells.
 */
public final class SquareGridView extends GridView {

    private static final String LOG_TAG = "multic-grid";

    // width/height of cell, computed in onMeasure(...)
    private int cellSize = 0;

    private ObjectAnimator[] animationsInProgress;

    //
    // constructors from parent
    //

    public SquareGridView(Context context) {
        super(context);
    }

    public SquareGridView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    public SquareGridView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    //
    // package
    //

    void init(XGameGridUiModel.Provider provider,
              AdapterView.OnItemClickListener clickListener) {

        GradientDrawable bkgnd = new GradientDrawable();
        bkgnd.setCornerRadius(4);
        setBackgroundDrawable(bkgnd);
        bkgnd.setColor(getResources().getColor(R.color.grid_background));

        setAdapter(new ContentProvider(getContext(), provider));
        setClickable(true);
        setOnItemClickListener(clickListener);
    }

    /**
     * Adjusts size and returns the computed size.
     */
    int adjustSize(View parent) {
        int parentHeight = parent.getHeight()
            - parent.getPaddingTop()
            - parent.getPaddingBottom();

        int parentWidth = parent.getWidth()
            - parent.getPaddingLeft()
            - parent.getPaddingRight();

        int size = (parentWidth < parentHeight)
            ? parentWidth
            : parentHeight;

        int contentSize = size - getPaddingLeft() - getPaddingRight();

        int cellSpacing
            = getResources().getDimensionPixelSize(R.dimen.grid_spacing);

        int numSpaces = getNumColumns() - 1;
        int totalSpacing = cellSpacing * numSpaces;
        int totalCellSizes = contentSize - totalSpacing;

        SquareGridView.this.cellSize = totalCellSizes / getNumColumns();

        // since last division may have caused rounding, compute actual
        final int actualSize
            = cellSize * getNumColumns() + totalSpacing
            + getPaddingBottom() + getPaddingTop();

        setColumnWidth(SquareGridView.this.cellSize);
        setLayoutParams(new LinearLayout.LayoutParams(size, size));

        ContentProvider contentProvider = getContentProvider();
        if (contentProvider != null)
            contentProvider.setCellSize(cellSize);

        return actualSize;
    }

    void refresh() {
        ContentProvider contentProvider = getContentProvider();
        if (contentProvider != null)
            contentProvider.updateAll();
    }

    void updateCell(int gridCellIfAny, AnimatorListener listenerIfAny) {
        ContentProvider contentProvider = getContentProvider();
        if (contentProvider != null)
            contentProvider.updateCell(gridCellIfAny, listenerIfAny);
    }

    void flashCell(int cellIndex, Animator.AnimatorListener listener) {
        ContentProvider contentProvider = getContentProvider();
        if (contentProvider != null)
            contentProvider.flashCell(cellIndex, listener);
    }

    void flashCells(int[] cellIndices, Animator.AnimatorListener listener) {
        ContentProvider contentProvider = getContentProvider();
        if (contentProvider != null)
            contentProvider.flashCells(cellIndices, listener);
    }

    //
    // private
    //

    private ContentProvider getContentProvider() {
        ListAdapter adapter = getAdapter();
        if (! (adapter instanceof ContentProvider)) {
            Log.w(LOG_TAG, "Unexpected adapter type: " + adapter);
            return null;
        }
        return (ContentProvider)adapter;
    }

    //
    // nested
    //

    /**
     * Content provider for the game grid.
     */
    public final class ContentProvider extends BaseAdapter {

        private final int COLOR_EMPTY;
        private final int COLOR_HUMAN;
        private final int COLOR_COMPUTER;
        private final int COLOR_TEXT;

        private final XGameGridUiModel.Provider uimProvider;
        private final TextView[] cellView;

        private GridView.LayoutParams layoutParams
            = new GridView.LayoutParams(10, 10);

        public ContentProvider(Context context,
                               XGameGridUiModel.Provider uimProvider /*,
                               View.OnClickListener cellClickListener*/) {
            if (context == null || uimProvider == null)
                throw new IllegalArgumentException();

            this.COLOR_COMPUTER
                = context.getResources().getColor(R.color.grid_cell_computer);
            this.COLOR_HUMAN
                = context.getResources().getColor(R.color.grid_cell_human);
            this.COLOR_EMPTY
                = context.getResources().getColor(R.color.grid_cell_empty);
            this.COLOR_TEXT
                = context.getResources().getColor(R.color.grid_cell_text);

            this.uimProvider = uimProvider;

            this.cellView = new TextView[getUim().getNumCells()];

            TextView textView;
            for (int i = 0; i < cellView.length; i++) {
                GradientDrawable bkgnd = new GradientDrawable();
                bkgnd.setCornerRadius(4);

                textView = new TextView(context);
                textView.setText(getUim().getCellContent(i));
                textView.setTypeface(null, Typeface.BOLD);
                textView.setTextSize(24);
                textView.setTextColor(COLOR_TEXT);
                textView.setLayoutParams(layoutParams);
                textView.setGravity(Gravity.CENTER);
                textView.setBackgroundDrawable(bkgnd);
                cellView[i] = textView;
                updateBackgroundColorForCell(i);

//                textView.setClickable(true);
//                textView.setOnClickListener(cellClickListener);
            }
        }

        //
        // BaseAdapter implementation
        //

        @Override
        public int getCount() {
            return getUim().getNumCells();
        }

        @Override
        public Object getItem(int i) {
            return null;
        }

        @Override
        public long getItemId(int i) {
            return 0;
        }

        @Override
        public View getView(int i, View view, ViewGroup viewGroup) {
            return cellView[i];
        }

        //
        // package
        //

        void updateCell(int cellIndex, AnimatorListener listener) {
            updateBackgroundColorForCell(cellIndex, COLOR_EMPTY, listener);
        }

        void updateAll() {
            if (animationsInProgress != null) {
                for (int i = 0; i < animationsInProgress.length; i++)
                    animationsInProgress[i].cancel();

                animationsInProgress = null;
            }

            for (int i = 0; i < cellView.length; i++)
                updateBackgroundColorForCell(i);
        }

        void setCellSize(int cellSize) {
            if (cellSize == layoutParams.height)
                return;

            this.layoutParams = new GridView.LayoutParams(cellSize, cellSize);
            for (int i = 0; i < cellView.length; i++)
                cellView[i].setLayoutParams(layoutParams);

            notifyDataSetChanged();
        }

        void flashCell(final int cellIndex, Animator.AnimatorListener listener) {
            int initialColor = getColorForCell(cellIndex);
            int endColor = (initialColor == COLOR_HUMAN)
                ? COLOR_COMPUTER
                : COLOR_HUMAN;

            animateCellColor(cellIndex, 70, 4, initialColor, endColor, listener);
        }

        void flashCells(int[] cellIndices, Animator.AnimatorListener listener) {
            animationsInProgress = new ObjectAnimator[cellIndices.length];
            for (int i = 0; i < cellIndices.length; i++) {
                int cellIndex = cellIndices[i];
                int initColor = getColorForCell(cellIndex);

                int r = (initColor >> 16) & 0xff;
                int g = (initColor >> 8) & 0xff;
                int b = initColor & 0xff;

                // choose darker color - divide each component by two
                int endColor
                    = (0xff << 24) | ((r/2) << 16) | ((g/2) << 8) | (b/2);

                animationsInProgress[i] = animateCellColor
                    (cellIndex, 1000, 4, initColor, endColor, listener);
            }
        }

        //
        // private
        //

        private ObjectAnimator animateCellColor
            (final int cellIndex,
             long duration,
             int repeatCount,
             final int initColor,
             int endColor,
             Animator.AnimatorListener listenerIfAny) {

            TextView view = cellView[cellIndex];
            ObjectAnimator colorAnim = ObjectAnimator.ofInt
                (view.getBackground(), "color", initColor, endColor);
            colorAnim.setDuration(duration);
            colorAnim.setEvaluator(new ArgbEvaluator());
            colorAnim.setRepeatCount(repeatCount);
            colorAnim.setRepeatMode(ValueAnimator.REVERSE);

            if (listenerIfAny != null)
                colorAnim.addListener(listenerIfAny);

            colorAnim.addListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    updateBackgroundColorForCell(cellIndex, initColor, null);
                }
             });

            colorAnim.start();

            return colorAnim;
        }

        private XGameGridUiModel getUim() {
            return uimProvider.get();
        }

        private int getColorForCell(int index) {
            Player p = getUim().getCellOccupantIfAny(index);
            return (p == Player.COMPUTER)
                ? COLOR_COMPUTER
                : (p == Player.HUMAN)
                    ? COLOR_HUMAN
                    : COLOR_EMPTY;
        }


        private void updateBackgroundColorForCell(int index) {
            updateBackgroundColorForCell(index, -1, null);
        }

        private void updateBackgroundColorForCell
            (int index, int initColor, AnimatorListener listenerIfAny) {

            int color = getColorForCell(index);
            TextView textView = cellView[index];

            if (initColor > 0)
                animateBacgkroundColorChange
                    (textView, initColor, color, listenerIfAny);
            else {
                ((GradientDrawable)textView.getBackground()).setColor(color);
                textView.invalidate();
            }
        }

        private void animateBacgkroundColorChange
            (final TextView textView,
             int initColor,
             int toColor,
             AnimatorListener listenerIfAny) {

            ValueAnimator colorAnimation = ValueAnimator.ofObject
                (new ArgbEvaluator(), initColor, toColor);

            colorAnimation.setDuration(600);

            colorAnimation.addUpdateListener(new AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator animator) {
                    setTextViewDrawableBkgndColor
                        (textView, ((Integer)animator.getAnimatedValue()));
                }
            });
            if (listenerIfAny != null)
                colorAnimation.addListener(listenerIfAny);
            colorAnimation.start();
        }

        private void setTextViewDrawableBkgndColor(TextView view,
                                                   Integer color) {
            ((GradientDrawable)view.getBackground()).setColor(color);
        }
    }
}
