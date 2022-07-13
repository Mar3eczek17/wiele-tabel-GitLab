-- Wprowadzenie
-- a. Napisz kwerendę, która zwróci wszystkich klientów z zamówieniami zrealizowanymi w dniu 2008-01-08
SELECT 
    *
FROM
    customer a,
    orders b
WHERE
    a.CUST_CODE = b.CUST_CODE
        AND b.ORD_DATE = '2008-01-08';
        
-- b. Napisz kwerendę, która zwróci listę agentów oraz klientów wraz z ich obszarem działalności, którzy należą do tego samego obszaru
SELECT 
    agents.AGENT_NAME, customer.CUST_NAME, customer.WORKING_AREA
FROM
    agents,
    customer
WHERE
    customer.WORKING_AREA = agents.WORKING_AREA;

-- INNER JOIN
-- a. Wyszukaj listę klientów, którzy podjęli współpracę z agentami spoza swojego obszaru działalności oraz tymi, których prowizja jest powyżej 12%; kolumna z nazwą pośrednika powinna mieć nazwę „Salesman”
SELECT 
    a.CUST_NAME AS 'Customer Name',
    a.WORKING_AREA,
    b.AGENT_NAME AS 'Salesman',
    b.COMMISSION
FROM
    customer a
        INNER JOIN
    agents b ON a.AGENT_CODE = b.AGENT_CODE
WHERE
    b.COMMISSION > .12; 
    
-- b. Wyszukaj szczegóły dot. Zamówień: nr zamówienia, datę, kwotę, klienta (nazwa kolumny powinna być „Customer Name”) oraz agenta (w tym wypadku nazwa kolumny to „Salesman”), który pracuje dla tego klienta oraz jego prowizję od zamówienia
SELECT 
    a.ORD_NUM,
    a.ORD_DATE,
    a.ORD_AMOUNT,
    b.CUST_NAME AS 'Customer Name',
    c.AGENT_NAME AS 'Salesman',
    c.COMMISSION
FROM
    orders a
        INNER JOIN
    customer b ON a.CUST_CODE = b.CUST_CODE
        INNER JOIN
    agents c ON a.AGENT_CODE = c.AGENT_CODE;

-- LEFT JOIN
-- a. Wyszukaj listę - posortowaną rosnąco wg kodu klienta (jego id) – klientów pracujących zarówno indywidualnie, jak również za pośrednictwem pośredników (nazwij kolumnę zawierającą nazwy pośredników jako „Salesman”), wyszukaj również ich obszar działalności
SELECT 
    a.CUST_NAME,
    a.WORKING_AREA,
    b.AGENT_NAME AS 'Salesman',
    b.WORKING_AREA
FROM
    customer a
        LEFT JOIN
    agents b ON a.AGENT_CODE = b.AGENT_CODE
ORDER BY a.CUST_CODE;

-- RIGHT JOIN
-- a. Wyszukaj listę pośredników pracujących dla jednego bądź więcej klientów lub takich, którzy jeszcze nie podjęli współpracy z żadnym klientem, posortuj listę rosnąco wg kolumny kodu pośrednika (agenta); nazwij kolumnę zawierającą nazwy pośredników jako „Salesman”, wyszukaj również ich obszar działalności
SELECT 
    a.CUST_NAME,
    a.WORKING_AREA,
    b.AGENT_NAME AS 'Salesman',
    b.WORKING_AREA
FROM
    customer a
        RIGHT OUTER JOIN
    agents b ON b.AGENT_CODE = a.AGENT_CODE
ORDER BY b.AGENT_CODE;

-- CROSS JOIN
-- a. Wyszukaj iloczyn kartezjański pośredników oraz klientów, w taki sposób, że każdy pośrednik będzie widoczny dla wszystkich klientów i vice versa.
SELECT 
    *
FROM
    agents a
        CROSS JOIN
    customer b;

-- b. Wyszukaj iloczyn kartezjański pośredników oraz klientów, w taki sposób, że każdy pośrednik będzie widoczny dla wszystkich klientów i vice versa, ale tylko jeżeli pośrednik jest z tego samego obszaru co klient.
SELECT 
    *
FROM
    agents a
        CROSS JOIN
    customer b
WHERE
    a.WORKING_AREA = b.WORKING_AREA;
    
-- c. Wyszukaj iloczyn kartezjański pośredników oraz klientów, w taki sposób, że każdy pośrednik będzie widoczny dla wszystkich klientów i vice versa, ale tylko jeżeli pośrednik jest z innego obszaru niż klient, a klient posiada swoją własną ocenę (‘grade’)
SELECT 
    *
FROM
    agents a
        CROSS JOIN
    customer b
WHERE
    b.GRADE IS NOT NULL
        AND a.WORKING_AREA IS NOT NULL
        AND b.WORKING_AREA != a.WORKING_AREA;

-- UNION
-- a. Wyszukaj wszystkich pośredników (ich kod – nazwij kolumne „ID” oraz nazwa agenta); przypisz im wartość ‘Salesman’ w kolumnie o nazwie „Rodzaj”) oraz klientów – ich ID i nazwa (wartość ‘Customer’ w kolumnie „Rodzaj”) zlokalizowanych w Londynie
SELECT 
    AGENT_CODE ID, AGENT_NAME, 'Salesman' AS 'Rodzaj'
FROM
    agents
WHERE
    WORKING_AREA = 'London' 
UNION (SELECT 
    cust_code ID, cust_name, 'Customer' AS 'Rodzaj'
FROM
    customer
WHERE
    WORKING_AREA = 'London');
    
-- b. Napisz kwerendę, która zwróci raport pokazujący, który pośrednik przyjął największe i najmniejsze zamówienia na każdy dzień
SELECT 
    a.AGENT_CODE,
    a.AGENT_NAME,
    b.ORD_NUM,
    'najwyższa',
    b.ORD_DATE
FROM
    agents a,
    orders b
WHERE
    a.AGENT_CODE = b.AGENT_CODE
        AND b.ORD_AMOUNT = (SELECT 
            MAX(ORD_AMOUNT)
        FROM
            orders c
        WHERE
            c.ORD_DATE = b.ORD_DATE) 
UNION (SELECT 
    a.AGENT_CODE,
    a.AGENT_NAME,
    b.ORD_NUM,
    'najniższa',
    b.ORD_DATE
FROM
    agents a,
    orders b
WHERE
    a.AGENT_CODE = b.AGENT_CODE
        AND b.ORD_AMOUNT = (SELECT 
            MIN(ORD_AMOUNT)
        FROM
            orders c
        WHERE
            c.ORD_DATE = b.ORD_DATE)); 

-- WITH
-- a. Wyszukaj pośrednika w Londynie z prowizją powyżej 14% - nazwij widok „londonstaff”
CREATE VIEW londonstaff AS
    SELECT 
        *
    FROM
        agents
    WHERE
        WORKING_AREA = 'London';
select * from londonstaff where londonstaff.commission>.14;

-- b. Utwórz widok „gradecount”, aby uzyskać liczbę klientów dla każdej oceny (‘grade’)
CREATE VIEW gradecount (grade , number) AS
    SELECT 
        grade, COUNT(*)
    FROM
        customer
    GROUP BY grade;

-- c. Utwórz widok (o nazwie „total_per_dzien”) do śledzenia liczby klientów, średniej kwoty zamówień oraz ogólnej sumy zamówień na każdy dzień
CREATE VIEW total_per_dzien AS
    SELECT 
        ord_date,
        COUNT(DISTINCT cust_code),
        AVG(ord_amount),
        SUM(ord_amount)
    FROM
        orders
    GROUP BY ord_date;
