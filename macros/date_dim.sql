{% macro create_date_dimension() %}
    CREATE TABLE date_dimension (
        id INT NOT NULL AUTO_INCREMENT,
        date DATE NOT NULL,
        month INT NOT NULL,
        quarter INT NOT NULL,
        year INT NOT NULL,
        day_of_week INT NOT NULL,
        day_of_month INT NOT NULL,
        day_name VARCHAR(9) NOT NULL,
        PRIMARY KEY (id)
    );

    DECLARE startDate DATE DEFAULT '2015-01-01';
    DECLARE endDate DATE DEFAULT CURRENT_DATE;
    WHILE startDate <= endDate DO
        INSERT INTO date_dimension(date, month, quarter, year, day_of_week, day_of_month, day_name)
        VALUES (
            startDate,
            MONTH(startDate),
            QUARTER(startDate),
            YEAR(startDate),
            DAYOFWEEK(startDate),
            DAYOFMONTH(startDate),
            DAYNAME(startDate)
        );
        SET startDate = DATE_ADD(startDate, INTERVAL 1 DAY);
    END WHILE;
{% endmacro %}
