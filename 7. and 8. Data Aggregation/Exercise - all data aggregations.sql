# data agregations exercise

# 1. Records' Count
SELECT COUNT(*) AS `count` FROM `wizzard_deposits`;
 
# 2. Longest Magic Wand
SELECT MAX(`magic_wand_size`) AS 'longest_magic_wand' FROM `wizzard_deposits`;
 
# 3. Longest Magic Wand Per Deposit Groups
SELECT `deposit_group`, MAX(`magic_wand_size`) AS 'longest_magic_wand' FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `longest_magic_wand` ASC, `deposit_group` ASC;
 
# 4. Smallest Deposit Group Per Magic Wand Size
SELECT `deposit_group` FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY AVG(`magic_wand_size`) ASC
LIMIT 1;
 
# 5. Deposits Sum
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum' FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `total_sum` ASC;
 
# 6. Deposits Sum for Ollivander Family
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum' FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group` ASC;
 
# 7. Deposits Filter
 
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum' FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;
 
# 8. Deposit Charge
SELECT `deposit_group`, `magic_wand_creator`, MIN(`deposit_charge`) AS 'min_deposit_charge' FROM `wizzard_deposits`
GROUP BY `deposit_group`, `magic_wand_creator`
ORDER BY `magic_wand_creator` ASC, `deposit_group` ASC;
 
# 9. Age Groups
SELECT (CASE 
			WHEN `age` BETWEEN 0 AND 10 THEN '[0-10]'
			WHEN `age` BETWEEN 11 AND 20 THEN '[11-20]'
			WHEN `age` BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN `age` BETWEEN 31 AND 40 THEN '[31-40]'
			WHEN `age` BETWEEN 41 AND 50 THEN '[41-50]'
			WHEN `age` BETWEEN 51 AND 60 THEN '[51-60]'
			WHEN `age` >= 61 THEN '[61+]'
		END) AS 'age_group', COUNT(`age`) AS 'wizard_count'
FROM `wizzard_deposits`
GROUP BY `age_group`
ORDER BY `wizard_count` ASC;
 
# 10. First Letter
SELECT LEFT(`first_name`, 1) AS 'first_letter' FROM `wizzard_deposits`
WHERE `deposit_group` = 'Troll Chest'
GROUP BY `first_letter`
ORDER BY `first_letter`;
 
# 11. Average Interest 
SELECT `deposit_group`, `is_deposit_expired`, AVG (`deposit_interest`) AS 'average_interest' FROM `wizzard_deposits`
WHERE `deposit_start_date` > '1985-01-01'
GROUP BY `deposit_group`, `is_deposit_expired`
ORDER BY `deposit_group` DESC, `is_deposit_expired` ASC;
 
# 12. Employees Minimum Salaries - начин 1
SELECT `department_id`, MIN(`salary`) AS 'minimum_salary' FROM `employees`
WHERE `hire_date` > '2000-01-01' 
GROUP BY `department_id`
HAVING `department_id` IN (2, 5, 7)
ORDER BY `department_id`;
 
# 12. Employees Minimum Salaries - начин 2
SELECT `department_id`, MIN(`salary`) AS 'minimum_salary' FROM `employees`
WHERE `hire_date` > '2000-01-01' AND `department_id` IN (2, 5, 7)
GROUP BY `department_id`
ORDER BY `department_id`;
 
# 13. Employees Average Salaries
 
# 13.1. Select all high paid employees who earn more than 30000 into a new table
CREATE TABLE `salary_more_than_30000` AS
SELECT * FROM `employees`
WHERE `salary` > 30000;
 
# 13.2. Then delete all high paid employees who have manager_id = 42 from the new table
DELETE FROM `salary_more_than_30000` 
WHERE `manager_id` = 42;
 
# 13.3. Then increase the salaries of all high paid employees with department_id = 1 with 5000 in the new table.
UPDATE `salary_more_than_30000`
SET `salary` = `salary` + 5000
WHERE `department_id` = 1;
 
# 13.4. select the average salaries in each department from the newtable. Sort result by department_id in increasing order.
SELECT `department_id`, AVG(`salary`) AS 'avg_salary' FROM `salary_more_than_30000`
GROUP BY `department_id`
ORDER BY `department_id` ASC;
 
# 14. Employees Maximum Salaries
SELECT `department_id`, MAX(`salary`) AS 'max_salary' FROM `employees`
GROUP BY `department_id`
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY `department_id`ASC;
 
# 15. Employees Count Salaries
SELECT COUNT(*) AS 'count' FROM `employees`
WHERE `manager_id` IS NULL;
 
# 16. 3rd Highest Salary
SELECT DISTINCT `department_id`, (
				# третата най-висока заплата
                SELECT DISTINCT `salary` FROM `employees` e1
                WHERE e1.`department_id` = `employees`.`department_id`
                ORDER BY `salary` DESC
                LIMIT 1 OFFSET 2
		) AS 'third_highest_salary' 
FROM `employees`
HAVING `third_highest_salary` IS NOT NULL
ORDER BY `department_id`;
 
 
# 17. Salary Challenge
SELECT `first_name`, `last_name`, `department_id` FROM `employees` AS e1
WHERE `salary` > (
		SELECT AVG(`salary`) FROM employees AS e2
        WHERE e1.department_id = e2.department_id  # средната заплата на отдела на служител e1
        )
ORDER BY `department_id`, `employee_id`
LIMIT 10;
 
 
# 18. Departments Total Salaries
SELECT `department_id`, SUM(`salary`) AS 'total_salary' FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;