Matlab tools
============

Many useful Matlab tools, look a bit at everything, you will likely find useful things for your project. It is not really documented but names of function are often enough.

I highly recommend the logger class that is really convenient to log many values during iterative experiments. 

Example:
```
rec = Logger();
for i = 1:50
    a = rand();
    rec.logit(a)
end
plot(rec.a)
rec.save('here.mat')
```

Then look at the plotting tools, as well as the logarithm tools if you play with probabilities.

Have fun!
