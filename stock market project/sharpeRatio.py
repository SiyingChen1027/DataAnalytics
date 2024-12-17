import numpy as np
from scipy.optimize import minimize

# 假设我们有四只股票的预期年收益率和协方差矩阵
expected_returns = np.array([0.12, 0.15, 0.10, 0.13])  # 这四只股票的预期收益率
cov_matrix = np.array([
    [0.04, 0.006, 0.004, 0.002],
    [0.006, 0.09, 0.006, 0.004],
    [0.004, 0.006, 0.05, 0.003],
    [0.002, 0.004, 0.003, 0.07]
])  # 这四只股票之间的协方差矩阵
risk_free_rate = 0.03  # 无风险利率

# 定义投资组合的预期收益和风险（标准差）
def portfolio_performance(weights, expected_returns, cov_matrix):
    returns = np.dot(weights, expected_returns)
    std_dev = np.sqrt(np.dot(weights.T, np.dot(cov_matrix, weights)))
    return returns, std_dev

# 定义目标函数 - 负的 Sharpe Ratio，因为我们用的是最小化函数
def neg_sharpe_ratio(weights, expected_returns, cov_matrix, risk_free_rate):
    returns, std_dev = portfolio_performance(weights, expected_returns, cov_matrix)
    sharpe_ratio = (returns - risk_free_rate) / std_dev
    return -sharpe_ratio  # 负号是因为我们在最小化

# 定义约束条件和初始权重
constraints = ({'type': 'eq', 'fun': lambda weights: np.sum(weights) - 1})
bounds = tuple((0, 1) for _ in range(len(expected_returns)))
initial_weights = [0.25, 0.25, 0.25, 0.25]

# 优化过程
result = minimize(neg_sharpe_ratio, initial_weights, args=(expected_returns, cov_matrix, risk_free_rate),
                  method='SLSQP', bounds=bounds, constraints=constraints)

# 输出结果
optimal_weights = result.x
optimal_sharpe_ratio = -result.fun
portfolio_return, portfolio_risk = portfolio_performance(optimal_weights, expected_returns, cov_matrix)

print("Optimal Weights:", optimal_weights)
print("Expected Portfolio Return:", portfolio_return)
print("Portfolio Risk (Standard Deviation):", portfolio_risk)
print("Sharpe Ratio of the Optimal Portfolio:", optimal_sharpe_ratio)
