import sys
import mysql.connector
from mysql.connector import errorcode

config = {
    "user": "whatabook_user",
    "password": "Hubcapsb109$!",
    "port": 3306,
    "database": "whatabook",
    "raise_on_warnings": True, 
}
# creates the main menu for user to choose from
def show_menu():
    print(" -- Main Menu --")
    print(" 1. View Our Locations \n 2. View Books In Stock \n 3. User Account \n 4. Exit")
#allows user to input an option
    try:
        choice = int(input('Enter an option:'))
        return choice
# for values not listed
    except ValueError:
        print("Select another option: ")
        sys.exit(0)
def ShowLocations(_cursor):
    _cursor.execute("SELECT store_id, locale FROM store")
    locations = _cursor.fetchall()
    print(" --Stores-- ")

    for location in locations:
        print("Local: {}\n".format(location[1]))
def show_books(_cursor):
    _cursor.execute ("SELECT book_id, book_name, author, details FROM book")
    books = _cursor.fetchall()
    print(" -- Books! -- ")
    for book in books:
        print("Book ID: {}\n Book Name:{}\n Author: {}\n Details: {}\n".format(book[0], book[1], book[2], book[3]))

def uservalidation():
    try:
        user_id = int(input('Enter user ID: '))
        if user_id < 0 or user_id > 3:
            print(" Option does not exist,. Pick another option")
            sys.exit(0)
        return user_id
#terminate program upon error
    except ValueError:
        print(" Option does not exist,. Pick another option")
        sys.exit(0)
def show_account_menu():
    try:
        print("-- Customer Menu --")
        print("1. View Wishlist \n 2. Add Book to Wishlist \n 3. Return to the Main Menu")
        account_option = int(input('Choose an option!'))
        return account_option
# Close the program if the account_option is invalid
    except ValueError:
        print("Option does not exist,. Pick another option")
        sys.exit(0)
def show_wishlist(_cursor, _user_id):
# Query for a list of the books available
    _cursor.execute("SELECT user.user_id, user.first_name, user.last_name, book.book_id, book.book_name, book.author " + "FROM wishlist " + "INNER JOIN user ON wishlist.user_id = user.user_id " + "INNER JOIN book ON wishlist.book_id = book.book_id " + "WHERE user.user_id = {}".format(_user_id))
# get results
    wishlist = _cursor.fetchall()
# display results
    print("-- Wishlist! --")
    for book in wishlist:
        print("Book Name:{}\n Author:{}\n".format(book[4], book[5]))
def books_in_queue(_cursor, _user_id):
# query for the list of books eligible to be added
    query = ("SELECT book_id, book_name, author, details FROM book WHERE book_id")
# display
    print(query)
# display results
    _cursor.execute(query)
    books_to_add = _cursor.fetchall()
    print("-- Available Books --")
    for book in books_to_add:
        print("Book ID: {}\n Book Name:{}\n".format(book[0], book[1]))
def add_book_to_wishlist(_cursor, _user_id, _book_id):
    _cursor.execute("INSERT INTO wishlist(user_id, book_id) VALUES({}, {})".format(_user_id, _book_id))

try:
    db = mysql.connector.connect(**config)
    cursor = db.cursor()
    print("Welcome!")

    while True:
        user_selection = show_menu()

        if user_selection == 1:
            ShowLocations(cursor)
        elif user_selection == 2:
            show_books(cursor)
        elif user_selection == 3:
            my_user_id = uservalidation()

            while True:
                account_option = show_account_menu()

                if account_option == 1:
                    show_wishlist(cursor, my_user_id)
                elif account_option == 2:
                    books_in_queue(cursor, my_user_id)
                    try:
                        book_id = int(input("Enter the id of the book you want to add:"))
                        # adds the book to the user's wishlist
                        add_book_to_wishlist(cursor, my_user_id, book_id)
                        db.commit()
                        print("Book ID: {} was added to your wishlist!".format(book_id))
                    except ValueError:
                        print("Invalid input. Please enter a valid Book ID.")
                elif account_option == 3:
                    break
                else:
                    print("invalid ID")
        elif user_selection == 4:
            break
        else:
            print("invalid option ")

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("invalid")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
    else:
        print(err)
finally:
    # close the connection to MySQL
    db.close()

