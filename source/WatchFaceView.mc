import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class WatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        dc.setAntiAlias(true);
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onUpdate(dc as Dc) as Void {
        var now = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        var dateLabel = View.findDrawableById("DateLabel") as Text;
        dateLabel.setText(
            Lang.format("$1$, $2$ $3$", [now.day_of_week, now.day, now.month])
        );

        var timeLabel = View.findDrawableById("TimeLabel") as Text;
        timeLabel.setText(
            Lang.format("$1$:$2$", [now.hour.format("%02d"), now.min.format("%02d")])
        );

        View.onUpdate(dc);
    }

}
