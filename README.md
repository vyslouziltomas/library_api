# Library API

REST API and web application for managing a library.

The application allows you to manage books and library members, record
borrowing and returning books, and view the complete borrowing history.

## Features

- Book management
  - create, edit and delete books
  - JSON bulk import
  - information about availability
- Member management
  - create, edit and delete members
- Book borrowing and returning
- Borrowing history
- CSV export of borrowing history
- REST API
- Web interface
- Database transactions for borrowing and returning books
- Model and controller tests

## Technologies

- Ruby 4.0.6
- Ruby on Rails 8.1.3
- PostgreSQL
- Minitest
- Puma

## Database

The application uses PostgreSQL.

The database contains three main tables:

- `members`
- `books`
- `borrowings`

A member can borrow multiple books.

A book can be either available or currently borrowed. The borrowing history
is stored separately and records every borrowing and returning operation.

## API Endpoints

### Members

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/members` | List all members |
| GET | `/api/members/:id` | Show a member |
| POST | `/api/members` | Create a member |
| PATCH | `/api/members/:id` | Update a member |
| DELETE | `/api/members/:id` | Delete a member |
| POST | `/api/members/import` | Import members from JSON |

### Books

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/books` | List all books |
| GET | `/api/books/:id` | Show a book |
| POST | `/api/books` | Create a book |
| PATCH | `/api/books/:id` | Update a book |
| DELETE | `/api/books/:id` | Delete a book |
| PATCH | `/api/books/:id/borrow` | Borrow a book |
| PATCH | `/api/books/:id/return_book` | Return a book |
| POST | `/api/books/import` | Import books from JSON |

### Borrowing history

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/borrowings` | Get borrowing history |
| GET | `/api/borrowings/export` | Export history as CSV |

## Web Interface

The application also provides a simple web interface:

- `/library` — available books and borrowing/returning
- `/members` — library members
- `/history` — borrowing history
- `/admin` — administration of books, members and history

## Running Locally

Install dependencies:

```bash
bundle install
```

Create and migrate the database:

```bash
rails db:create
rails db:migrate
```

Start the server:

```bash
rails server
```

The application will be available at:

http://localhost:3000

## Running Tests

Run the complete test suite:

```bash
rails test
```

The project currently contains 33 tests and 72 assertions.

## Deployment

The application is prepared for deployment using PostgreSQL.