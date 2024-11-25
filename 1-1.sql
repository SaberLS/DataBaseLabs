-- 1
-- 1. Napisz polecenie select za pomocą którego uzyskasz identyfikator/numer tytułu oraz
-- tytuł książki
SELECT
    title_no
    ,title
    ,author
FROM
    title
-- 2. Napisz polecenie, które wybiera tytuł o numerze/identyfikatorze 10
SELECT
    title
FROM
    title
WHERE title_no = 10
-- 3. Napisz polecenie select, za pomocą którego uzyskasz numer książki (nr tyułu) i
-- autora dla wszystkich książek, których autorem jest Charles Dickens lub Jane Austen
SELECT
    title_no
    ,author
FROM
    title
WHERE author IN('Charles Dickens', 'Jane Austen')

-- 2
-- 1. Napisz polecenie, które wybiera numer tytułu i tytuł dla wszystkich książek, których
-- tytuły zawierających słowo 'adventure'
SELECT
    title_no
    ,title
FROM
    title
WHERE title LIKE('%adventure%')

-- 2. Napisz polecenie, które wybiera numer czytelnika, oraz zapłaconą karę dla wszystkich
-- książek, tore zostały zwrócone w listopadzie 2001
SELECT
    member_no
    ,fine_paid
    ,in_date
FROM
    loanhist
WHERE MONTH(in_date) = 11 AND YEAR(in_date) = 2001

-- 3. Napisz polecenie, które wybiera wszystkie unikalne pary miast i stanów z tablicy
-- adult .
SELECT
    DISTINCT
    [state]
    ,city
FROM
    adult
-- 4. Napisz polecenie, które wybiera wszystkie tytuły z tablicy title i wyświetla je w
-- porządku alfabetycznym.
SELECT
    title
FROM
    title
ORDER BY title ASC


-- 3
-- Napisz polecenie, które:
SELECT-- wybiera
    member_no -- numer członka biblioteki ( member_no ),
    ,isbn -- isbn książki ( isbn )
    ,fine_assessed -- i wartość naliczonej kary (fine_assessed)
    ,2 * fine_assessed AS double_fine --stwórz kolumnę wyliczeniową zawierającą 
    -- podwojoną wartość kolumny fine_assessed
    -- stwórz alias double_fine dla tej kolumny
    -- (zmień nazwą kolumny na double_fine )
    ,2 * fine_assessed - fine_assessed AS diff-- stwórz kolumnę o nazwie diff
-- zawierającą różnicę wartości w kolumnach double_fine i fine_assessed
FROM
    loanhist-- z tablicy loanhist
WHERE
    fine_assessed IS NOT NULL -- dla wszystkich których naliczono karę wypożyczeń/zwrotów, dla (wartość nie NULL w kolumnie fine_assessed )
    AND 2 * fine_assessed - fine_assessed > 3-- wybierz wiersze dla których wartość w kolumnie diff jest większa niż 3

-- 4
-- generuje pojedynczą kolumnę, która zawiera kolumny: firstname (imię członka
-- biblioteki), middleinitial (inicjał drugiego imienia) i lastname (nazwisko) z
-- tablicy member dla wszystkich członków biblioteki, którzy nazywają się Anderson
-- nazwij tak powstałą kolumnę email_name (użyj aliasu email_name dla kolumny)
SELECT
    firstname + middleinitial + lastname AS email_name
FROM
    member
WHERE lastname = 'Anderson'

-- zmodyfikuj polecenie, tak by zwróciło 'listę proponowanych loginów e-mail'
-- utworzonych przez połączenie imienia członka biblioteki, z inicjałem drugiego imienia i
-- pierwszymi dwoma literami nazwiska (wszystko małymi małymi literami).
-- wykorzystaj funkcję SUBSTRING do uzyskania części kolumny znakowej oraz LOWER
-- do zwrócenia wyniku małymi literami.
-- wykorzystaj operator (+) do połączenia napisów.
-- dla wszystkich członków biblioteki, którzy nazywają się Anderson
SELECT
    LOWER(firstname + middleinitial + SUBSTRING(lastname,1, 2)) AS email_name
FROM
    member
WHERE lastname = 'Anderson'

-- 5
-- 1. Napisz polecenie, które wybiera title i title_no z tablicy title .
-- wynikiem powinna być pojedyncza kolumna o formacie jak w przykładzie poniżej:
-- The title is: Poems, title number 7
-- czyli zapytanie powinno zwracać pojedynczą kolumnę w oparciu o wyrażenie,
-- które łączy 4 elementy:
-- stała znakowa ‘The title is:ʼ
-- wartość kolumny title
-- stała znakowa ‘title numberʼ
-- wartość kolumny title_no
SELECT
    'The title is: ' + title + ' title number: ' + CONVERT(VARCHAR, title_no) AS title
FROM
    title
