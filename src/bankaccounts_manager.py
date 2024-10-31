import psycopg


conn = psycopg.connect(
    dbname="bankaccount_db",
    user="postgres",
    password="password",
    host="localhost",
    port="5432"
)
cursor = conn.cursor()


cursor.execute('''
    CREATE TABLE IF NOT EXISTS account (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100),
        email VARCHAR(100),
        phone VARCHAR(15)
    );
''')
conn.commit()


def add_bankaccount(name, email, phone):
    cursor.execute('''
        INSERT INTO account (name, email, phone)
        VALUES (%s, %s, %s);
    ''', (name, email, phone))
    conn.commit()
    print("Bank account added successfully!")


def view_bankaccounts():
    cursor.execute('SELECT * FROM account;')
    bankaccounts = cursor.fetchall()
    for bankaccount in bankaccounts:
        print(f"ID: {bankaccount[0]}, Name: {bankaccount[1]}, Email: {bankaccount[2]}, Phone: {bankaccount[3]}")


def update_bankaccount(bankaccount_id, name, email, phone):
    cursor.execute('''
        UPDATE account
        SET name = %s, email = %s, phone = %s
        WHERE id = %s;
    ''', (name, email, phone, bankaccount_id))
    conn.commit()
    print("Bank account updated successfully!")


def delete_bankaccount(bankaccount_id):
    cursor.execute('DELETE FROM account WHERE id = %s;', (bankaccount_id,))
    conn.commit()
    print("Bank account deleted successfully!")


def menu():
    while True:
        print("\n--- PNC Bank Account Manager ---")
        print("1. Add Bank Account")
        print("2. View Bank Accounts")
        print("3. Update Bank Account")
        print("4. Delete Bank Account")
        print("5. Exit")

        choice = input("Enter your choice: ")

        if choice == '1':
            name = input("Enter name: ")
            email = input("Enter email: ")
            phone = input("Enter phone: ")
            add_bankaccount(name, email, phone)
        elif choice == '2':
            view_bankaccounts()
        elif choice == '3':
            bankaccount_id = input("Enter the bank account ID to update: ")
            name = input("Enter new name: ")
            email = input("Enter new email: ")
            phone = input("Enter new phone: ")
            update_bankaccount(bankaccount_id, name, email, phone)
        elif choice == '4':
            bankaccount_id = input("Enter the bank account ID to delete: ")
            delete_bankaccount(bankaccount_id)
        elif choice == '5':
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == '__main__':
    menu()


cursor.close()
conn.close()
