//
//  ViewController.m
//  Multithreading-Semaphore
//
//  Created by MichaelMao on 2018/6/28.
//  Copyright © 2018年 frizzlefur. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
//  [self testSemaphore];
  [self testLoopSemaphore];
}

- (void) testSemaphore {
  dispatch_semaphore_t lock  = dispatch_semaphore_create(1);
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    NSLog(@"%s","First task starting");
    sleep(1);
    NSLog(@"%s", "First task is done");
    sleep(1);
    dispatch_semaphore_signal(lock);
  
  });
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    NSLog(@"%s","Second task starting");
    sleep(1);
    NSLog(@"%s", "Second task is done");
    sleep(1);
    dispatch_semaphore_signal(lock);
    
  });
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    NSLog(@"%s","Thrid task starting");
    sleep(1);
    NSLog(@"%s", "Thrid task is done");
    sleep(1);
    dispatch_semaphore_signal(lock);
  
  });
}


- (void)testLoopSemaphore {
  
  // 1. 创建锁🔐
  
  dispatch_semaphore_t lock  = dispatch_semaphore_create(4); //设置信号总量
  
  NSLog(@"11111111");
  
  // 2. 拿到全局队列，循环创建第一种任务
  
  for (NSInteger i = 0; i < 10; i++) {
    // 由于是异步执行的，所以每次循环Block里面的dispatch_semaphore_signal根本还没有执行就会执行dispatch_semaphore_wait，从而semaphore-1.当循环10此后，semaphore等于0，则会阻塞线程，直到执行了Block的dispatch_semaphore_signal 才会继续执行
    //参考https://www.jianshu.com/p/04ca5470f212
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER); //信号量-1
      sleep(2);
      NSLog(@"0~~~~~~~~%zd~~~~~~~~~%@", i, [NSThread currentThread]);
      dispatch_semaphore_signal(lock);  //信号量+1
    });
    
  }
  
  NSLog(@"2222222222");
  
  // 3. 拿到全局队列，循环创建第二种任务
  
  for (NSInteger i = 0; i < 10; i++) {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
      sleep(2);
      NSLog(@"1~~~~~~~~%zd~~~~~~~~~%@", i, [NSThread currentThread]);
      dispatch_semaphore_signal(lock);
    });
    
  }
  // 4. 打印结束
  
  NSLog(@"3333333333");

}

@end
