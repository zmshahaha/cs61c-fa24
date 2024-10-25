# lab-starter


## classify

callee saved用处:整个函数都要用

举例

如果使用caller saved，那么下面的t0需要保存很多次(在每次call一个函数时候都要保存)

```
li t0, 100 # 要用t0
# 需要保存t0
call func1
# 恢复t0
li t0, 101 # 要用t0
# 需要保存t0
call func2
# 恢复t0
```

而如果使用callee saved，则只需要保存一次(func1和func2不用s0前提下)

如果func1和func2不用s0，只需保存一次

```
li s0, 100
# 保存s0
call func1
call func2
# 恢复s0
```

