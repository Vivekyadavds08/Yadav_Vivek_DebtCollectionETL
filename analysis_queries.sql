-- a. What is the average loan amount for borrowers who are more than 5 days past due?

SELECT round(AVG(loan_amount) ,2) as avg_loan_amt
FROM borrowers 
WHERE days_left_to_pay_current_emi > 5 AND delayed_payment = 'Yes';

-- b. Who are the top 10 borrowers with the highest outstanding balance?

SELECT b.id, b.name, b.loan_amount - COALESCE(SUM(r.payment_mode), 0) as outstanding_balance
FROM borrowers b
LEFT JOIN repayment_history r ON b.id = r.borrower_id
GROUP BY b.id, b.name, b.loan_amount
ORDER BY outstanding_balance DESC
LIMIT 10;

-- c. List of all borrowers with good repayment history?

SELECT b.id, b.name
FROM borrowers b
WHERE b.id NOT IN (
  SELECT r.borrower_id
  FROM repayment_history r
  WHERE r.payment_date > (SELECT loan_term FROM borrowers WHERE id = r.borrower_id)
);

-- d. Brief analysis wrt loan type

-- 1 Number of loans by type:

SELECT loan_type, COUNT(*) as num_loans 
FROM borrowers 
GROUP BY loan_type;

-- 2 Average loan amount by type:

SELECT loan_type, AVG(loan_amount) as avg_loan_amount 
FROM borrowers 
GROUP BY loan_type;

-- 3 Outstanding loan amount by type:

SELECT loan_type, SUM(loan_amount) - COALESCE(SUM(r.payment_mode), 0) as outstanding_loan_amount
FROM borrowers b
LEFT JOIN repayment_history r ON b.id = r.borrower_id
GROUP BY loan_type
ORDER BY outstanding_loan_amount DESC;