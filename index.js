import {NativeModules} from 'react-native';

const {RNSy, NativeEventEmitter} = NativeModules;

class SyManage extends NativeEventEmitter {
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

    login(cb) {
        RNSy.login(cb);
    }
}

let Sy = new SyManage();
export default Sy;
