import {NativeModules, PermissionsAndroid, Platform, NativeEventEmitter} from 'react-native';

const {RNSy} = NativeModules;

export default new class SyManage extends NativeEventEmitter {
    // 构造
    constructor(props) {
        super(RNSy);
        // 初始状态
        this.state = {};
    }

    init(appid, debug, cb) {

        RNSy.init(appid, debug, cb);
    }

    preGetPhonenumber(cb) {
        RNSy.preGetPhonenumber(cb);
    }

    login(cb, style) {
        RNSy.login(style, cb);
    }
};
