WITH AllCombinations AS (
    SELECT
        s.student_id,
        s.student_name,
        sub.subject_name
    FROM
        Students s
    CROSS JOIN
        Subjects sub
)
SELECT
    ac.student_id,
    ac.student_name,
    ac.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM
    AllCombinations ac
LEFT JOIN
    Examinations e
ON
    ac.student_id = e.student_id AND ac.subject_name = e.subject_name
GROUP BY
    ac.student_id, ac.student_name, ac.subject_name
ORDER BY
    ac.student_id, ac.subject_name;
