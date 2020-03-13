import {NativeModules, PermissionsAndroid, Platform} from 'react-native';

const {RNSy, NativeEventEmitter} = NativeModules;

class SyManage extends NativeEventEmitter {
    // 构造
    constructor(props) {
        super(RNSy);
        // 初始状态
        this.state = {};
    }

    init(appid, debug, cb) {
        if (Platform.OS == 'android') {
            PermissionsAndroid.check(PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE).then((state) => {
                if (state) {
                    RNSy.init(appid, debug, cb);
                } else {
                    PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE).then((granted) => {
                        RNSy.init(appid, debug, cb);
                    });
                }
            });
        } else {

            RNSy.init(appid, debug, cb);
        }
    }

    preGetPhonenumber(cb) {
        RNSy.preGetPhonenumber(cb);
    }

    login(cb, style) {
        RNSy.login(style, cb);
    }
}

let Sy = new SyManage();
export default Sy;
