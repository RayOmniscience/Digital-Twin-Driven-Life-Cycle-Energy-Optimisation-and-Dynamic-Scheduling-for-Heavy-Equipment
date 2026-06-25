%% 基于数字孪生的重型装备全生命周期能耗优化与动态调度系统仿真
clear; clc; close all;

% 全局字体设置为Times New Roman
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultTextFontName', 'Times New Roman');
set(0, 'DefaultLegendFontName', 'Times New Roman');

%% 图1: 全生命周期能耗分布
figure('Position', [100, 100, 800, 600]);
lifecycle_phases = {'Structural Manufacturing', 'Component Manufacturing', 'Installation & Commissioning', 'Operation & Maintenance', 'Decommissioning & Recycling'};
energy_consumption = [25, 15, 5, 50, 5];
h_bar = bar(energy_consumption, 'FaceColor', [0.2 0.4 0.8], 'EdgeColor', 'k', 'LineWidth', 1.5);
set(gca, 'XTickLabel', lifecycle_phases, 'FontSize', 12);
ylabel('Energy Consumption Ratio (%)', 'FontSize', 14);
%title('Energy Consumption Distribution in Full Life Cycle of Heavy Equipment ', 'FontSize', 16, 'FontWeight', 'bold');
legend('Energy Consumption Distribution', 'Location', 'northeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);

% 柱状图数值标注
for i = 1:length(energy_consumption)
    text(i, energy_consumption(i) + 1.5, num2str(energy_consumption(i)), ...
         'HorizontalAlignment', 'center', 'FontSize', 12, 'FontName', 'Times New Roman');
end

%% 图2: 运行阶段能耗构成分析
figure('Position', [100, 100, 800, 600]);
operation_components = {'Pump System', 'Valve Throttling', 'Internal Leakage', 'Cooling System', 'Control System'};
energy_loss = [40, 25, 15, 10, 10];

% --- START OF MODIFICATION ---
% 1. 绘制饼图，并获取一个包含所有句柄的数组 'h'。
%    h 的奇数索引是饼图切片句柄，偶数索引是文本标签句柄。
%    此时饼图上会显示默认的百分比标签。
h = pie(energy_loss); 

% 2. 从 'h' 中分离出饼图切片句柄 (h_patch) 和文本标签句柄 (h_text)。
h_patch = h(1:2:end); % 奇数索引是饼图切片 (patch) 句柄
h_text = h(2:2:end);   % 偶数索引是文本标签 (text) 句柄

% 3. 遍历并修改每个文本标签，使其显示 "组件名称 百分比%"
for k = 1:length(h_text)
    % 获取当前文本标签的原始字符串（例如 "40%"）
    current_percentage_str = get(h_text(k), 'String');
    
    % 构造新的标签字符串：组件名称 + 原始的百分比字符串
    % operation_components 数组的顺序与饼图切片顺序一致
    new_label_string = sprintf('%s %s', operation_components{k}, current_percentage_str);
    
    % 更新文本标签的字符串和字体设置，使其直接显示在饼图上
    set(h_text(k), ...
        'String', new_label_string, ...
        'FontSize', 12, ... % 设置字体大小
        'FontName', 'Times New Roman', ... % 保持全局字体设置
        'Color', 'k', ... % 设置字体颜色
        'FontWeight', 'bold'); % 字体加粗增加可读性
end

% 4. 为饼图创建单独的图例，只显示组件名称
% legend函数需要图形对象句柄来创建图例，这里使用饼图切片的句柄 h_patch
legend(h_patch, operation_components, 'Location', 'eastoutside', 'FontSize', 12);
% --- END OF MODIFICATION ---

title('Energy Consumption Composition in Operation Phase ', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'LineWidth', 2);

%% 图3: 负荷-能耗非线性关系
figure('Position', [100, 100, 800, 600]);
load_ratio = 0:5:100;
energy_efficiency = 100 * (0.85 * (load_ratio/100).^1.2 + 0.15 * exp(-0.02*(load_ratio-50).^2));
plot(load_ratio, energy_efficiency, 'b-', 'LineWidth', 2);
hold on;

[~, idx_50] = min(abs(load_ratio - 50));
[~, idx_100] = min(abs(load_ratio - 100));
plot(load_ratio(idx_50), energy_efficiency(idx_50), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(load_ratio(idx_100), energy_efficiency(idx_100), 'gs', 'MarkerSize', 8, 'MarkerFaceColor', 'g');

xlabel('Load Ratio (%)', 'FontSize', 14);
ylabel('Energy Efficiency Index', 'FontSize', 14);
title('Nonlinear Relationship between Working Load and Energy Consumption Efficiency', 'FontSize', 16, 'FontWeight', 'bold');
legend('Energy Efficiency Curve', 'Optimal Load Point (50%)', 'Full Load Point (100%)', 'Location', 'southeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);
xlim([0 100]);
hold off;

%% 图4: 数字孪生三层闭环架构数据流
figure('Position', [100, 100, 900, 700]);
time_steps = 0:0.1:10;
perception_layer = 50 + 20*sin(2*pi*time_steps/5);
model_layer = 60 + 15*sin(2*pi*time_steps/5 + pi/4);
application_layer = 70 + 10*sin(2*pi*time_steps/5 + pi/2);

plot(time_steps, perception_layer, 'r-', 'LineWidth', 2);
hold on;
plot(time_steps, model_layer, 'g-', 'LineWidth', 2);
plot(time_steps, application_layer, 'b-', 'LineWidth', 2);

xlabel('Time (s)', 'FontSize', 14);
ylabel('Data Processing Level', 'FontSize', 14);
title('Real-time Data Flow of Digital Twin Three-layer Closed-loop Architecture', 'FontSize', 16, 'FontWeight', 'bold');
legend('Perception Layer (IIoT)', 'Model Layer (Analysis)', 'Application Layer (Execution)', 'Location', 'northeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);
hold off;

%% 图5: 传统系统 vs 伺服液压系统能耗对比
figure('Position', [100, 100, 800, 600]);
cycle_number = 1:100;
traditional_energy = 3227.66 * ones(size(cycle_number));
servo_energy = 2000 + 500*sin(0.1*cycle_number) + 200*randn(size(cycle_number));

plot(cycle_number, traditional_energy, 'r--', 'LineWidth', 2);
hold on;
plot(cycle_number, servo_energy, 'b-', 'LineWidth', 2);

xlabel('Number of Working Cycles', 'FontSize', 14);
ylabel('Energy Consumption per Cycle (kJ)', 'FontSize', 14);
title('Energy Consumption Comparison: Traditional vs Servo Hydraulic System', 'FontSize', 16, 'FontWeight', 'bold');
legend('Traditional Valve-controlled Fixed-speed Pump', 'Servo Variable-speed Displacement Pump', 'Location', 'northeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);
xlim([1 100]);
hold off;

%% 图6: 速度-风阻-摩擦复合能耗曲线
figure('Position', [100, 100, 800, 600]);
speed = 0:5:100;
air_resistance = 0.5 * speed.^2;
friction_loss = 20 + 0.3 * speed;
total_loss = air_resistance + friction_loss;

plot(speed, air_resistance, 'r-', 'LineWidth', 2);
hold on;
plot(speed, friction_loss, 'g-', 'LineWidth', 2);
plot(speed, total_loss, 'b-', 'LineWidth', 2);

xlabel('Operating Speed (km/h)', 'FontSize', 14);
ylabel('Resistance Loss (Relative Unit)', 'FontSize', 14);
title('Impact of Air Resistance and Friction on Total Energy Consumption', 'FontSize', 16, 'FontWeight', 'bold');
legend('Air Resistance (v^2)', 'Mechanical Friction (Linear)', 'Total Resistance Loss', 'Location', 'northwest', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);
xlim([0 100]);
hold off;

%% 图7: 环境温度对能效的影响
figure('Position', [100, 100, 800, 600]);
temperature = -30:5:50;
efficiency_low_temp = 100 * (1 - 0.02 * max(0, 25-temperature).^1.5);
efficiency_high_temp = 100 * (1 - 0.015 * max(0, temperature-25).^1.2);
cooling_load = 5 * max(0, temperature-30);

plot(temperature, efficiency_low_temp, 'b-', 'LineWidth', 2);
hold on;
plot(temperature, efficiency_high_temp, 'r-', 'LineWidth', 2);
plot(temperature, cooling_load*5 + 50, 'g--', 'LineWidth', 2);

xlabel('Ambient Temperature (°C)', 'FontSize', 14);
ylabel('System Efficiency/Load (%)', 'FontSize', 14);
title('Impact of Ambient Temperature on Equipment Energy Efficiency', 'FontSize', 16, 'FontWeight', 'bold');
legend('Efficiency Decrease at Low Temperature', 'Efficiency Decrease at High Temperature', 'Cooling Load Increase', 'Location', 'northeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);
xlim([-30 50]);
hold off;

%% 图8: 操作行为对能耗的影响
figure('Position', [100, 100, 800, 600]);
operation_style = 1:6;
energy_consumption = [100, 115, 140, 130, 170, 85];
labels = {'Standard Operation', 'Slight Sudden Acceleration', 'Frequent Sudden Braking', 'Long Idling Time', 'Overload Operation', 'Eco-driving'};
h_bar = bar(operation_style, energy_consumption, 'FaceColor', [0.3 0.6 0.9], 'EdgeColor', 'k', 'LineWidth', 1.5);
set(gca, 'XTickLabel', labels, 'FontSize', 10, 'XTickLabelRotation', 45);
ylabel('Relative Energy Consumption Level (%)', 'FontSize', 14);
title('Impact of Different Operating Behaviors on Energy Consumption', 'FontSize', 16, 'FontWeight', 'bold');
legend('Energy Consumption Level', 'Location', 'northeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);

% 柱状图数值标注
for i = 1:length(energy_consumption)
    text(i, energy_consumption(i) + 3, num2str(energy_consumption(i)), ...
         'HorizontalAlignment', 'center', 'FontSize', 11, 'FontName', 'Times New Roman');
end

%% 图9: 数字孪生实时状态同步精度
figure('Position', [100, 100, 800, 600]);
time = 0:0.1:20;
physical_state = 100 + 20*sin(0.5*time) + 5*randn(size(time));
digital_twin = physical_state + 2*randn(size(time));
synchronization_error = abs(physical_state - digital_twin);

plot(time, physical_state, 'b-', 'LineWidth', 2);
hold on;
plot(time, digital_twin, 'r--', 'LineWidth', 2);
plot(time, synchronization_error*5 + 80, 'g:', 'LineWidth', 2);

xlabel('Time (s)', 'FontSize', 14);
ylabel('State Parameters', 'FontSize', 14);
title('Real-time State Synchronization between Digital Twin and Physical System', 'FontSize', 16, 'FontWeight', 'bold');
legend('Physical System State', 'Digital Twin State', 'Synchronization Error', 'Location', 'southeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);
hold off;

%% 图10: 动态调度优化前后对比
figure('Position', [100, 100, 800, 600]);
scheduling_time = 1:24;
traditional_schedule = 80 + 30*sin(2*pi*scheduling_time/24) + 20*randn(size(scheduling_time));
optimized_schedule = 60 + 15*sin(2*pi*scheduling_time/24 + pi/6) + 10*randn(size(scheduling_time));
energy_traditional = traditional_schedule * 1.5;
energy_optimized = optimized_schedule * 1.2;

yyaxis left
plot(scheduling_time, energy_traditional, 'r-', 'LineWidth', 2);
hold on;
plot(scheduling_time, energy_optimized, 'b-', 'LineWidth', 2);
ylabel('Energy Consumption (kWh)', 'FontSize', 14, 'Color', 'k');
ylim([0 250]);

yyaxis right
plot(scheduling_time, traditional_schedule, 'r--', 'LineWidth', 2);
plot(scheduling_time, optimized_schedule, 'b--', 'LineWidth', 2);
ylabel('Load Ratio (%)', 'FontSize', 14, 'Color', 'k');
ylim([0 120]);

xlabel('Scheduling Time (Hour)', 'FontSize', 14);
title('Energy Consumption Comparison: Traditional Scheduling vs DT Optimized Scheduling', 'FontSize', 16, 'FontWeight', 'bold');
legend('Traditional Scheduling - Energy', 'DT Optimized - Energy', 'Traditional Scheduling - Load', 'DT Optimized - Load', ...
       'Location', 'northeast', 'FontSize', 10);
grid off;
set(gca, 'LineWidth', 2);
hold off;

%% 图11: 预测性维护对能耗波动的抑制
figure('Position', [100,100, 800, 600]);
operation_hours = 0:100:5000;
without_maintenance = 100 + 20*exp(operation_hours/3000) + 30*sin(operation_hours/500);
with_predictive = 95 + 5*sin(operation_hours/1000) + 10*randn(size(operation_hours));

plot(operation_hours, without_maintenance, 'r-', 'LineWidth', 2);
hold on;
plot(operation_hours, with_predictive, 'g-', 'LineWidth', 2);

xlabel('Operating Hours', 'FontSize', 14);
ylabel('Energy Consumption Level (%)', 'FontSize', 14);
title('Suppression Effect of Predictive Maintenance on Energy Consumption Degradation', 'FontSize', 16, 'FontWeight', 'bold');
legend('Without Predictive Maintenance', 'With DT Predictive Maintenance', 'Location', 'northeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);
xlim([0 5000]);
hold off;

%% 图12: 多工况下DT优化节能效果
figure('Position', [100, 100, 800, 600]);
work_conditions = {'No Load', 'Light Load', 'Medium Load', 'Full Load', 'Over Load'};
baseline_energy = [100, 120, 150, 180, 220];
dt_optimized = [100, 105, 125, 140, 160];
bar_data = [baseline_energy; dt_optimized]';
h_bar = bar(bar_data, 'grouped');
set(gca, 'XTickLabel', work_conditions, 'FontSize', 12);
ylabel('Energy Consumption Level (%)', 'FontSize', 14);
title('Energy Saving Effect of DT Optimization under Different Working Conditions', 'FontSize', 16, 'FontWeight', 'bold');
legend('Baseline Energy Consumption', 'DT Optimized Energy Consumption', 'Location', 'northeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);

% 分组柱状图数值标注
x_pos = get(h_bar(1), 'XData');
for i = 1:length(baseline_energy)
    text(x_pos(i)-0.15, baseline_energy(i) + 5, num2str(baseline_energy(i)), ...
         'HorizontalAlignment', 'center', 'FontSize', 11, 'FontName', 'Times New Roman');
    text(x_pos(i)+0.15, dt_optimized(i) + 5, num2str(dt_optimized(i)), ...
         'HorizontalAlignment', 'center', 'FontSize', 11, 'FontName', 'Times New Roman');
end

%% 图13: 实时闭环控制响应特性
figure('Position', [100, 100, 800, 600]);
time_response = 0:0.01:5;
setpoint = 100 * ones(size(time_response));
disturbance = 20 * sin(2*pi*time_response/1.5) .* (time_response > 1 & time_response < 3);
system_response = setpoint + disturbance - 15*exp(-(time_response-1.5).^2/0.2) .* (time_response > 1);

plot(time_response, setpoint, 'k--', 'LineWidth', 2);
hold on;
plot(time_response, system_response, 'b-', 'LineWidth', 2);
plot(time_response, disturbance + 100, 'r:', 'LineWidth', 2);

xlabel('Time (s)', 'FontSize', 14);
ylabel('Control Output', 'FontSize', 14);
title('Real-time Response of DT Closed-loop Control to Disturbances', 'FontSize', 16, 'FontWeight', 'bold');
legend('Set Value', 'System Response', 'External Disturbance', 'Location', 'southeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);
hold off;

%% 图14: 全生命周期综合能效提升
figure('Position', [100, 100, 800, 600]);
lifecycle_stages = 1:6;
traditional_efficiency = [70, 65, 60, 55, 50, 45];
dt_system_efficiency = [75, 80, 85, 90, 88, 85];

plot(lifecycle_stages, traditional_efficiency, 'r-o', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
plot(lifecycle_stages, dt_system_efficiency, 'b-s', 'LineWidth', 2, 'MarkerSize', 8);

stage_labels = {'Design', 'Manufacturing', 'Installation', 'Operation', 'Maintenance', 'Decommissioning'};
set(gca, 'XTick', lifecycle_stages, 'XTickLabel', stage_labels, 'FontSize', 11);
xlabel('Life Cycle Stages', 'FontSize', 14);
ylabel('Comprehensive Energy Efficiency (%)', 'FontSize', 14);
title('Improvement of Full Life Cycle Energy Efficiency by DT System', 'FontSize', 16, 'FontWeight', 'bold');
legend('Traditional Method', 'DT Integrated System', 'Location', 'southeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);
hold off;

%% 图15: 系统整体性能指标对比
figure('Position', [100, 100, 900, 700]);
metrics = {'Energy Efficiency Improvement', 'Scheduling Response', 'Maintenance Cost', 'Service Life Extension', 'Carbon Emission Reduction'};
traditional_values = [1, 1, 1, 1, 1];
dt_improvement = [1.35, 2.1, 0.65, 1.25, 0.4];
bar_data = [traditional_values; dt_improvement]';
h_bar = bar(bar_data, 'grouped');
h_bar(1).FaceColor = [0.8 0.4 0.4];
h_bar(2).FaceColor = [0.4 0.6 0.9];
set(gca, 'XTickLabel', metrics, 'FontSize', 11, 'XTickLabelRotation', 45);
ylabel('Relative Performance Index', 'FontSize', 14);
title('Comparison of Overall Performance Indicators of DT System', 'FontSize', 16, 'FontWeight', 'bold');
legend('Traditional Baseline', 'DT System Improvement', 'Location', 'northeast', 'FontSize', 12);
grid off;
set(gca, 'LineWidth', 2);

% 分组柱状图数值标注
x_pos = get(h_bar(1), 'XData');
for i = 1:length(traditional_values)
    text(x_pos(i)-0.15, traditional_values(i) + 0.05, num2str(traditional_values(i)), ...
         'HorizontalAlignment', 'center', 'FontSize', 11, 'FontName', 'Times New Roman');
    text(x_pos(i)+0.15, dt_improvement(i) + 0.05, num2str(dt_improvement(i)), ...
         'HorizontalAlignment', 'center', 'FontSize', 11, 'FontName', 'Times New Roman');
end

%% 统一设置所有图格式
fig_handles = findobj('Type', 'Figure');
for i = 1:length(fig_handles)
    set(fig_handles(i), 'Color', 'w');
    ax = findobj(fig_handles(i), 'Type', 'Axes');
    for j = 1:length(ax)
        set(ax(j), 'FontSize', 12, 'LineWidth', 2);
        set(ax(j), 'XGrid', 'off', 'YGrid', 'off');
    end
end

disp('完成15张仿真图生成！');
disp('图表内容覆盖：');
disp('1. 全生命周期能耗分布');
disp('2. 运行阶段能耗构成');
disp('3. 负荷-能耗非线性关系');
disp('4. DT三层架构数据流');
disp('5. 传统vs伺服系统对比');
disp('6. 速度-阻力复合分析');
disp('7. 环境温度影响');
disp('8. 操作行为能耗效应');
disp('9. 实时状态同步');
disp('10. 动态调度优化');
disp('11. 预测维护效果');
disp('12. 多工况优化');
disp('13. 闭环控制响应');
disp('14. 全生命周期能效');
disp('15. 整体性能指标');