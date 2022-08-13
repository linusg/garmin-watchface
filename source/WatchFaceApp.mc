import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class WatchFaceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new WatchFaceView() ] as Array<Views or InputDelegates>;
    }

}

function getApp() as WatchFaceApp {
    return Application.getApp() as WatchFaceApp;
}
