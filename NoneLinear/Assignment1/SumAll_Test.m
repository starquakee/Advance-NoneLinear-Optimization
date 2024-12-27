% 测试样例 1：没有输入参数
disp('Test 1: No input');
output1 = SumAll();
disp('Expected output: 0');
disp(['Actual output: ', num2str(output1)]);
disp('--------------------------------');

% 测试样例 2：有 5 个输入参数
disp('Test 2: Input [1, 2, 3, 4, 5]');
output2 = SumAll(1, 2, 3, 4, 5);
disp('Expected output: 1+2+3+4+5=15');
disp(['Actual output: ', num2str(output2)]);
disp('--------------------------------');

% 测试样例 3：有 3 个输入参数
disp('Test 3: Input [10, 20, 30]');
output3 = SumAll(10, 20, 30);
disp('Expected output: 10+20+30=60');
disp(['Actual output: ', num2str(output3)]);
disp('--------------------------------');

% 测试样例 4：有 1 个输入参数
disp('Test 4: Input [100]');
output4 = SumAll(100);
disp('Expected output: 100=100');
disp(['Actual output: ', num2str(output4)]);
disp('--------------------------------');

% 测试样例 5：负数输入
disp('Test 5: Input [-1, -2, -3]');
output5 = SumAll(-1, -2, -3);
disp('Expected output: -1+-2+-3=-6');
disp(['Actual output: ', num2str(output5)]);
disp('--------------------------------');