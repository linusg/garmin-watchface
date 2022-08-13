import Toybox.Graphics;
import Toybox.Lang;

module Icons {

    function drawAlarmIcon(
        dc as Dc, x as Number, y as Number, scale as Float, options as Null
    ) as Void {
        dc.setPenWidth(5 * scale);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(x, y, 20 * scale);
        dc.drawLine(x, y - 10 * scale, x, y);
        dc.drawLine(x, y, x - 6 * scale, y + 8 * scale);
        dc.drawLine(x + 17 * scale, y - 23 * scale, x + 23 * scale, y - 17 * scale);
        dc.drawLine(x - 17 * scale, y - 23 * scale, x - 23 * scale, y - 17 * scale);
    }

    // Monkey C compiler doesn't understand Array<Array<T>> for some reason?
    typedef ArrayOfNumeric as Array<Numeric>;

    function drawNotificationIcon(
        dc as Dc, x as Number, y as Number, scale as Float, options as Null
    ) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(
            x - 25 * scale,
            y - 20 * scale,
            50 * scale,
            35 * scale,
            4
        );
        dc.fillPolygon([
            [x - 15 * scale, y + 15 * scale] as Array<Numeric>,
            [x - 15 * scale, y + 25 * scale] as Array<Numeric>,
            [x, y + 15 * scale] as Array<Numeric>,
        ] as Array<ArrayOfNumeric>);
    }

}
