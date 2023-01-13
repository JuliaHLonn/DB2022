# DB2022

## Beskrivning

I kursen DB2022 på IT-Högskolan skulle vi redovisa på färdigheter i SQL, Normalisering samt Java mot en relationsdatabas. Detta är min redovisning från denna kurs.
Mermaid är ett verktyg för att rita diagram i Markdown. Istället för exemplevis Lucidchart, valde vi Mermaid, för att få grafen kodnära.

## Entity Relationship Diagram
---
Den normaliserade UNF tabellen
---
```mermaid
erDiagram
Student || --o{ Phone
Student {
int StudentId
String FirstName
String LastName
int GradeId
}

Phone {
int PhoneId
int StudentId
int PhoneTypeId
varchar Number
}

PhoneType || --o{ Phone
PhoneType {
int PhoneTypeId
varchar Type
}

School || --o{ StudentSchool
Student || --o{ StudentSchool
School {
int SchoolId
varchar Name
varchar City
}

StudentSchool {
int StudentId
int SchoolId
}
Grade |o --|{ Student
Grade {
int GradeId
varchar Name
}

Hobbies || --o{ StudentHobbies
Student || --o{ StudentHobbies
Hobbies {
int HobbyId
varchar Name
}

StudentHobbies {
int HobbyId
int StudentId
}
```
## Klona
> git clone https://github.com/JuliaHLonn/DB2022.git
>
> cd DB2022

## Normalisera databas
> docker exec -i iths-mysql mysql -uiths -piths < normalisering.sql

## Kör Java koden
> docker exec -i iths-mysql mysql -uiths -piths < db.sql
>
> docker exec -i iths-mysql mysql -uroot -proot <<< "GRANT ALL ON Chinook.* TO 'iths'@'%'"
>
> idea.cmd .
>
> Projektet öppnas nu i intellij där du kan köra applikationen
