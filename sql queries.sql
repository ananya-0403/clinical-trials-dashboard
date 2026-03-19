CREATE TABLE trials (
    nct_number VARCHAR(20) PRIMARY KEY,
    study_title TEXT,
    study_url TEXT,
    study_status VARCHAR(50),
    conditions TEXT,
    interventions TEXT,
    sponsor TEXT,
    collaborators TEXT,
    study_type VARCHAR(50)
);
SELECT * FROM trials LIMIT 10;

SELECT 
    COUNT(*) FILTER (WHERE study_status IS NULL) AS missing_status,
    COUNT(*) FILTER (WHERE conditions IS NULL) AS missing_conditions
FROM trials;

SELECT 
    study_status,
    COUNT(*) AS total_trials
FROM trials
GROUP BY study_status
ORDER BY total_trials DESC;

SELECT 
    study_type,
    COUNT(*) AS total
FROM trials
GROUP BY study_type;

SELECT 
    conditions,
    COUNT(*) AS count
FROM trials
GROUP BY conditions
ORDER BY count DESC
LIMIT 10;

SELECT 
    sponsor,
    COUNT(*) AS trials_count
FROM trials
GROUP BY sponsor
ORDER BY trials_count DESC
LIMIT 10;

SELECT 
    interventions,
    COUNT(*) AS total
FROM trials
GROUP BY interventions
ORDER BY total DESC
LIMIT 10;

CREATE TABLE trial_conditions AS
SELECT 
    nct_number,
    UNNEST(STRING_TO_ARRAY(conditions, '|')) AS condition
FROM trials;

SELECT condition, COUNT(*) 
FROM trial_conditions
GROUP BY condition
ORDER BY COUNT(*) DESC
LIMIT 10;



ALTER TABLE trials ADD COLUMN category VARCHAR;

UPDATE trials
SET category = 
    CASE 
        WHEN conditions ILIKE '%cancer%' THEN 'Oncology'
        WHEN conditions ILIKE '%parkinson%' OR conditions ILIKE '%neuro%' THEN 'Neurology'
        WHEN conditions ILIKE '%infection%' THEN 'Infectious'
        ELSE 'Other'
    END;

SELECT category, COUNT(*) 
FROM trials
GROUP BY category;