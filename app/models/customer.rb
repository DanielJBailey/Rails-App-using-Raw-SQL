class Customer < ApplicationRecord
  belongs_to :user

  # Instance Method
  def full_name
    #"#{self.first_name} #{self.last_name}"
    customer = Customer.find_by_sql(["
        SELECT 
        first_name, last_name 
        from customers AS c
        WHERE c.id = ?
      ", self.id]).first
      "#{customer.first_name} #{customer.last_name}"
  end

  # Model Method
  # Select all customer records for user
  def self.all_customers(user_id)
    Customer.find_by_sql("
      SELECT *
      FROM customers AS c
      WHERE c.user_id = #{user_id}
    ")
  end

  # Select a single customer for user
  def self.single_customer(user_id, customer_id)
    Customer.find_by_sql(["
        SELECT * 
        FROM customers AS c
        WHERE c.user_id = ?
        AND c.id = ?
      ", user_id, customer_id]).first
  end

  # Create a single customer
  def self.create_customer(params, user_id)
    Customer.find_by_sql(["
        INSERT INTO customers (first_name, last_name, email, phone, user_id, created_at, updated_at)
        VALUES (:first, :last, :email, :phone, :user_id, :created_at, :updated_at)
      ", {
        first: params[:first_name],
        last: params[:last_name],
        email: params[:email],
        phone: params[:phone],
        user_id: user_id,
        created_at: DateTime.now,
        updated_at: DateTime.now
      }])
  end

  # Update a single customer
  def self.update_customer(params, customer_id, user_id)
    Customer.find_by_sql(["
        UPDATE customers AS c
        SET first_name = ?, last_name = ?, email = ?, phone = ?, updated_at = ?
        WHERE c.id = ? AND c.user_id = ?
      ", params[:first_name], params[:last_name], params[:email], params[:phone], DateTime.now, customer_id, user_id])
  end

  # Delete a single customer
  def self.delete_customer(user_id, customer_id)
    Customer.find_by_sql(["
        DELETE FROM customers AS c
        WHERE c.user_id = ? AND c.id = ?
      ", user_id, customer_id])
  end
end



# IF USER ID IS A STRING OR USER NAME IS IN STRING FORMAT, YOU HAVE TO PASS IT IN AS FOLLOWS
# # Model Method
# def self.all_customers(user_id)
#   Customer.find_by_sql(["
#       SELECT *
#       FROM customers AS c
#       WHERE c.user_id = ?
#     ", user_id])
# end
