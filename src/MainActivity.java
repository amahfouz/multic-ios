
package com.mahfouz.multic.android;

import kankan.wheel.widget.OnWheelScrollListener;
import kankan.wheel.widget.WheelView;
import kankan.wheel.widget.adapters.NumericWheelAdapter;
import android.animation.Animator;
import android.animation.Animator.AnimatorListener;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.res.Configuration;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.mahfouz.multic.R;
import com.mahfouz.multic.core.Difficulty;
import com.mahfouz.multic.core.Knob;
import com.mahfouz.multic.core.Player;
import com.mahfouz.multic.core.MulticException;
import com.mahfouz.multic.uim.XGameGridUiModel;
import com.mahfouz.multic.uim.XGameModel;
import com.mahfouz.multic.util.MulticLog;

/**
 * Main activity for the application.
 */
public final class MainActivity extends Activity {

    private static final String LOG_TAG = "mul-tic-tac-toe";
    private static final String PLAY_AGAIN_MESSAGE = "Tap grid to play again";

    private XGameModel game;

    private SquareGridView grid;
    private WheelView firstKnob;
    private WheelView secondKnob;
    private TextView messageView;
    private Toast curToast;

    private boolean hasAdjustedLayout;

    //
    // Activity implementation
    //

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        MulticApplication app = (MulticApplication)getApplication();

        Object savedGameState = getLastNonConfigurationInstance();
        this.game = (savedGameState instanceof XGameModel)
            ? (XGameModel)savedGameState
            : (app.getGameModelIfAny() != null)
                ? app.getGameModelIfAny()
                : createNewGame();

        // store game in app to restore on activity recreation
        app.storeGameModel(game);

        game.setListener(new GameUimListener());

        setContentView(R.layout.activity_main);

        this.grid = (SquareGridView)findViewById(R.id.gameBoardView);

        AdapterView.OnItemClickListener gridClickListener
            = new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {
                // if game is over start new game
                if (game.getTurnPlayer() == null)
                    startNewGame();
            }
        };

        grid.init(new XGameGridUiModel.Provider() {
            public XGameGridUiModel get() {
                return game.getGridUiModel();
            }
        }, gridClickListener);

        this.firstKnob = setupSpinner(R.id.firstKnob);
        this.secondKnob = setupSpinner(R.id.secondKnob);
        this.messageView = (TextView)findViewById(R.id.messageView);

        GradientDrawable bkgnd = new GradientDrawable();
        bkgnd.setCornerRadius(10);
        messageView.setBackgroundDrawable(bkgnd);

        syncupControlsWithModel();

        SharedPreferences sp = getSharedPrefs();
        boolean isFirstTime = sp.getBoolean("first-time", true);
        if (isFirstTime) {
            sp.edit().putBoolean("first-time", false).commit();
            startActivity(new Intent(this, HelpActivity.class));
        }

        grid.getViewTreeObserver().addOnGlobalLayoutListener(new GlobalLayoutListener());
    }

    @Override
    protected void onRestart() {
        super.onRestart();  // Always call the superclass method first

        // Check if difficulty level has changed

        Difficulty prefDifficulty = MulticPrefs.getDifficulty();
        boolean difficultyChanged = prefDifficulty != game.getDifficulty();
        boolean computerShouldStart
            =  (! MulticPrefs.humanStarts())
            && XGameGridUiModel.Util.isEmpty(game.getGridUiModel());

        if (difficultyChanged || computerShouldStart)
            startNewGame();
    }

    @Override
    protected void onPause() {
        hideCurToast();
        super.onPause();
    }

    //
    // public methods
    //

    @Override
    public Object onRetainNonConfigurationInstance() {
        // retain game state on orientation change
        return game;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle presses on the action bar items
        switch (item.getItemId()) {
            case R.id.action_settings:
                startActivity(new Intent(this, SettingsActivity.class));
                return true;

            case R.id.action_help:
                startActivity(new Intent(this, HelpActivity.class));
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu items for use in the action bar
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.main_activity_actions, menu);
        return super.onCreateOptionsMenu(menu);
    }

    /**
     * OnClick handler for the "New Game" button.
     */
    public void startNewGame(View view) {
        startNewGame();
    }

    //
    // private
    //

    private void hideCurToast() {
        if (curToast != null) {
            curToast.cancel();
            curToast = null;
        }
    }

    private void startNewGame() {
        showToast("Starting new game", false);

        this.game = createNewGame();

        syncupControlsWithModel();
    }

    private XGameModel createNewGame() {
        MulticLog log = (getApplication().getApplicationInfo().flags
                         & ApplicationInfo.FLAG_DEBUGGABLE) == 0
            ? null
            : new MulticLog() {
                public void warn(String message) {
                    Log.w(LOG_TAG, message);
                }

                public void info(String message) {
                    Log.i(LOG_TAG, message);
                }

                public void debug(String message) {
                    Log.d(LOG_TAG, message);
                }
            };

        return new XGameModel(MulticPrefs.getDifficulty(),
                              new GameUimListener(),
                              getIsRandomStart(),
                              log);
    }


    private boolean getIsRandomStart() {
        return getSharedPrefs().getBoolean
            (getString(R.string.pref_name_random_start), false);
    }

    private SharedPreferences getSharedPrefs() {
        return getSharedPreferences
            (getString(R.string.shared_pref_name), MODE_PRIVATE);
    }

    private WheelView setupSpinner(int viewId) {
        final WheelView knob = (WheelView) findViewById(viewId);
        NumericWheelAdapter wheelAdapter
            = new NumericWheelAdapter(this, 1, Knob.MAX_FACTOR);
        wheelAdapter.setItemResource(R.layout.wheel_item);
        wheelAdapter.setItemTextResource(R.id.wheel_item);
        knob.setViewAdapter(wheelAdapter);
        knob.setCyclic(true);
        knob.addScrollingListener(new WheelScrollListener());

        return knob;
    }

    private void updateViewState() {
        Player nextTurn = game.getTurnPlayer();

        Log.i(LOG_TAG, "Updating view. Turn = " + nextTurn);

        setKnobEnablement(nextTurn == Player.HUMAN);

        if (nextTurn == null) {
            // game has ended

            Player winnerIfAny = game.getWinnerIfAny();

            if (winnerIfAny == Player.HUMAN)
                announceWinAndPromptRestart("You win!", true);
            else if (winnerIfAny == Player.COMPUTER)
                announceWinAndPromptRestart("Computer wins!", false);
            else {
                showMessage("Game drawn!", true);
                showToast(PLAY_AGAIN_MESSAGE, true);
            }
        }
        else {
            String msg = (nextTurn == Player.COMPUTER)
                ? "Thinking..."
                : "Your turn!";
            showMessage(msg, nextTurn == Player.HUMAN);
        }
    }

    private void announceWinAndPromptRestart(String message, boolean isHuman) {
        AnimatorListenerAdapter flashListener = new AnimatorListenerAdapter() {
            public void onAnimationEnd(Animator animation) {
                runOnUiThread(new Runnable() {
                    public void run() {
                        showToast(PLAY_AGAIN_MESSAGE, true);
                    }
                });
            }
        };

        showMessage(message, isHuman);
        grid.flashCells(game.getWinningFourIfAny(), flashListener);
    }

    private void showToast(String message, boolean isLong) {
        hideCurToast();

        this.curToast = Toast.makeText
            (MainActivity.this, message,
             isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT);
        curToast.setGravity
            (Gravity.CENTER_HORIZONTAL|Gravity.CENTER_VERTICAL, 0, 0);
        curToast.show();
    }

    private void showMessage(String message, boolean isHuman) {
        messageView.setText(message);

        int color = getResources().getColor
            (isHuman
                 ? R.color.grid_cell_human
                 : R.color.grid_cell_computer);

        ((GradientDrawable) messageView.getBackground()).setColor(color);
    }

    private void setKnobEnablement(boolean isEnabled) {
        Log.i(LOG_TAG, "Set knob enablement to " + isEnabled);
        firstKnob.setEnabled(isEnabled);
        firstKnob.setFocusable(isEnabled);
        firstKnob.setFocusableInTouchMode(isEnabled);

        secondKnob.setEnabled(isEnabled);
        secondKnob.setFocusable(isEnabled);
        secondKnob.setFocusableInTouchMode(isEnabled);
    }

    private void syncupControlsWithModel() {
        this.grid.refresh();

        this.firstKnob.setCurrentItem
            (game.getSelectedIndexFor(Knob.Location.TOP));
        this.secondKnob.setCurrentItem
            (game.getSelectedIndexFor(Knob.Location.BOTTOM));

        updateViewState();
    }

    //
    // nested
    //

    private final class WheelScrollListener implements OnWheelScrollListener {

        private boolean scrollInProgress = false;
        /**
         * Ensure that user is only allowed to scroll on wheel at a time.
         *
         * Disable one wheel as soon as the other is touched and re-enables
         * when done.
         */
        public void onScrollingStarted(WheelView wheel) {
            if (! scrollInProgress) {
                scrollInProgress = true;
                setOtherWheelEnabled(wheel, false);
            }
        }

        public void onScrollingFinished(final WheelView wheel) {
            Log.i(LOG_TAG, "Wheel Scroll Finished " + wheel.getCurrentItem());

            scrollInProgress = false;
            // re-enable wheel that got disabled when scrolling started
            setOtherWheelEnabled(wheel, true);

            int viewId = wheel.getId();

            final Knob.Location knobLoc = (viewId == R.id.firstKnob)
                ? Knob.Location.TOP
                : (viewId == R.id.secondKnob)
                    ? Knob.Location.BOTTOM
                    : null;

            if (knobLoc == null) {
                Log.w(LOG_TAG, "Invalid view ID: " + viewId);
                return;
            }

            // scrolling ended but user did not change the position
            if (game.getSelectedIndexFor(knobLoc) == wheel.getCurrentItem())
                return;

            try {
                // disable knobs to avoid extra clicks
                setKnobEnablement(false);
                game.makeUserMove(knobLoc, wheel.getCurrentItem());
            }
            catch (MulticException ex) {
                showMessage(ex.getMessage(), true);

                AnimatorListenerAdapter cellFlashListener
                    = new AnimatorListenerAdapter() {

                        public void onAnimationEnd(Animator animation) {
                            // revert the invalid selection when anim is done
                            wheel.setCurrentItem
                                (game.getSelectedIndexFor(knobLoc), true);
                        }
                };

                if (ex.getCellIfAny() != null)
                    grid.flashCell
                        (ex.getCellIfAny().getCellIndex(), cellFlashListener);
            }
            finally {
                updateViewState();
            }
        }

        private void setOtherWheelEnabled(WheelView wheel, boolean enabled) {
            WheelView otherWheel = (wheel.getId() == R.id.firstKnob)
                ? secondKnob
                : firstKnob;

            otherWheel.setEnabled(enabled);
        }
    }

    private final class GameUimListener implements XGameModel.Listener {

        public void cellStateChanged(final int gridCellIfAny) {
            final AnimatorListener listener = new AnimatorListenerAdapter() {
                public void onAnimationEnd(Animator animation) {
                    updateViewState();
                }
            };

            runOnUiThread(new Runnable() {
                public void run() {
                    if (gridCellIfAny >= 0)
                        grid.updateCell(gridCellIfAny, listener);
                }
            });
        }

        public void knobStateChanged(final Knob.Location knobLoc) {
            runOnUiThread(new Runnable() {
                public void run() {
                    handleKnobStateChanged(knobLoc);
                }
            });
        }

        private void handleKnobStateChanged(final Knob.Location knobLoc) {
            final WheelView view = (knobLoc == Knob.Location.TOP)
                ? firstKnob
                : (knobLoc == Knob.Location.BOTTOM)
                    ? secondKnob
                    : null;

            if (view == null) {
                Log.d(LOG_TAG, "View not created yet.");
                return;
            }

            int newIndex = game.getSelectedIndexFor(knobLoc);
            Log.i(LOG_TAG, "Updating " + knobLoc + " knob to " + newIndex);

            view.setCurrentItem(newIndex, true);
        }
    }

    private final class GlobalLayoutListener
        implements ViewTreeObserver.OnGlobalLayoutListener {

        public void onGlobalLayout() {
            // size of parent view is known when this method is called

            if (hasAdjustedLayout)
                return;

            // ensure this path is taken only once

            hasAdjustedLayout = true;

            LinearLayout root = (LinearLayout)findViewById(R.id.rootView);
            LinearLayout horz = (LinearLayout)findViewById(R.id.horizLayout);

            int gridSize = grid.adjustSize(root);

            if (getResources().getConfiguration().orientation
                == Configuration.ORIENTATION_PORTRAIT) {

                int totalConsumedHeight
                    = root.getPaddingTop()
                    + messageView.getHeight()
                    + horz.getPaddingTop() + horz.getPaddingBottom()
                    + gridSize
                    + root.getPaddingBottom();

                int wheelHeight = root.getHeight() - totalConsumedHeight;

                firstKnob.getLayoutParams().height = wheelHeight;
                secondKnob.getLayoutParams().height = wheelHeight;
            }
            else {
                // landscape
                firstKnob.getLayoutParams().height = gridSize * 6 / 10;
                secondKnob.getLayoutParams().height = gridSize * 6 / 10;
            }
        }
    }
}
