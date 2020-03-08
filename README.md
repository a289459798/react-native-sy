
# react-native-sy

集成闪验一键登录SDK

## 效果

![image](/pic/xg.gif)

## Getting started

`$ npm install git+https://gitee.com/petdoctor/react-native-sy.git --save`

### Mostly automatic installation

`$ react-native link react-native-sy`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-sy` and add `RNSy.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNSy.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.ichong.zzy.sy.RNSyPackage;` to the imports at the top of the file
  - Add `new RNSyPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-sy'
  	project(':react-native-sy').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-sy/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-sy')
  	```


## Usage
```javascript
import RNSy from 'react-native-sy';

// 在入口文件的js里面，初始化
Sy.init(Config.Sy.AppId, Config.DEBUG, (code, data) => {
    if (code != 1000) {
        console.log('闪验初始化失败：', data);
    }
});


// 在登录页面，调用一键登录，目前已弹窗形式

Sy.login((res, data) => {
    if (res == 1000) {
        // 业务代码，server 端用token获取手机号码
        console.log(data.token)
    } else {
        console.error(data);
    }

})
```
