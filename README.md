# Timer-used-DispatchSourceTimer
인하대 수강신청을 모방한 타이머 앱
<img width="1493" alt="스크린샷 2022-11-01 오후 9 21 39" src="https://user-images.githubusercontent.com/102133961/199236372-8d453057-5abb-4542-9191-b057117553b0.png">
<img width="1792" alt="스크린샷 2022-11-01 오후 9 16 46" src="https://user-images.githubusercontent.com/102133961/199236395-9781621a-8926-4aeb-9497-756558911293.png">
<img width="1505" alt="스크린샷 2022-11-01 오후 9 17 03" src="https://user-images.githubusercontent.com/102133961/199236399-89915b72-6d1e-49b5-9916-3b0a44224b35.png">
<img width="1512" alt="스크린샷 2022-11-01 오후 2 22 56" src="https://user-images.githubusercontent.com/102133961/199236402-11720f3c-c9e4-400c-8f86-dac9acd9cbc9.png">

시간이 지남에 따라 화면 색이 변하고

원하는 말을 실시간으로 텍스트 뷰에 넣을 수 있으며

타이머 기능도 착실하게 들어갔다

## 😎DispatchSourceTimer로 타이머 만들기

**Protocol
DispatchSourceTimer**

A dispatch source that submits the event handler block based on a timer.

iOS 8.0+iPadOS 8.0+macOS 10.10+Mac Catalyst 13.0+tvOS 9.0+watchOS 2.0+Xcode 8.0+

## **Declaration**

`protocol DispatchSourceTimer`

## **Overview**

You do not adopt this protocol in your objects. Instead, use the `[makeTimerSource(flags:queue:)](https://developer.apple.com/documentation/dispatch/dispatchsource/2300106-maketimersource)` method to create an object that adopts this protocol.

## **Topics**

****Scheduling the Timer Trigger Conditions****

`[func schedule(deadline: DispatchTime, repeating: DispatchTimeInterval, leeway: DispatchTimeInterval)](https://developer.apple.com/documentation/dispatch/dispatchsourcetimer/2920392-schedule)`

Schedules a timer with the specified deadline, repeat interval, and leeway values.

`[func schedule(deadline: DispatchTime, repeating: Double, leeway: DispatchTimeInterval)](https://developer.apple.com/documentation/dispatch/dispatchsourcetimer/2920395-schedule)`

Schedules a timer with the specified deadline, repeat interval, and leeway values.

`[func schedule(wallDeadline: DispatchWallTime, repeating: DispatchTimeInterval, leeway: DispatchTimeInterval)](https://developer.apple.com/documentation/dispatch/dispatchsourcetimer/2920391-schedule)`

Schedules a timer with the specified time, repeat interval, and leeway values.

`[func schedule(wallDeadline: DispatchWallTime, repeating: Double, leeway: DispatchTimeInterval)](https://developer.apple.com/documentation/dispatch/dispatchsourcetimer/2920390-schedule)`

Schedules a timer with the specified time, repeat interval, and leeway values.

위는 Apple developer에 나와있는 DispatchSourceTimer의 정보이다

DispatchSourceTimer의 사용법은 비교적 간단하다. 타이머를 만들고(DispatchSource.makeTimerSource(flags: , queue:)), 

스케줄을 지정하고(deadline과 repeating 지정), 

이벤트 핸들러를 명시하고 (timer?.setEventHandler(handler: {

}) )

타이머를 시작하면 된다. 특히 원하는 스레드 큐에서 반복해서 동작하도록 할 수 있어서 백그라운드 타이머로 만들기 좋을 것 같지…만

그렇게 또 간단하기만 한 녀석은 아니다

Timer 생성자의 **queue**에는 원하는 작업이 UI와 관련되어 있다면 **Main**을 할당해주어야 한다(이건 저번주에 배운 바 있다)

바로 실행되어야 한다면 **deadline**에 .now()만 할당하면 되고, 3초 후에 실행되어야 한다면 .now() + 3 을 할당해주면 된다. 1초마다 반복되도록 **repeating**에는 1을 할당하였다.

Timer와 함께 연동될 **EventHandler**를 할당한다.

```swift
// 시작
timer?.resume()

// 일시정지
timer?.suspend()

// 종료
timer?.cancel()
timer = nil

```

Timer를 종료할 땐 Timer에 꼭 nil을 할당해서 메모리에서 해제시켜야 한다. 그렇지 않다면 화면을 벗어나도 Background에서 계속 동작하고 있다…혼자서 외롭게 말이다.
