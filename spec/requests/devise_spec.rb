require "rails_helper"

RSpec.describe "User Registration (Devise)", type: :request do
  describe "POST /users (signup)" do
    let(:valid_params) do
      {
        user: {
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post user_registration_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "automatically creates a Company for the user" do
        expect {
          post user_registration_path, params: valid_params
        }.to change(Company, :count).by(1)
      end

      it "associates the user with the created company" do
        post user_registration_path, params: valid_params
        user = User.find_by(email: "newuser@example.com")
        expect(user.company).not_to be_nil
      end

      it "uses user's email in company name" do
        post user_registration_path, params: valid_params
        user = User.find_by(email: "newuser@example.com")
        expect(user.company.name).to include("newuser@example.com")
      end

      it "generates a unique CNPJ for the company" do
        post user_registration_path, params: valid_params
        user = User.find_by(email: "newuser@example.com")
        expect(user.company.cnpj_id).not_to be_nil
      end

      it "redirects to appropriate page after signup" do
        post user_registration_path, params: valid_params
        expect(response).to have_http_status(:redirect)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          user: {
            email: "invalid-email",
            password: "short",
            password_confirmation: "different"
          }
        }
      end

      it "does not create a new User" do
        expect {
          post user_registration_path, params: invalid_params
        }.not_to change(User, :count)
      end

      it "does not create a Company" do
        expect {
          post user_registration_path, params: invalid_params
        }.not_to change(Company, :count)
      end
    end

    context "when email already exists" do
      before { create(:user, email: "existing@example.com") }

      it "does not create a new User" do
        expect {
          post user_registration_path, params: {
            user: {
              email: "existing@example.com",
              password: "password123",
              password_confirmation: "password123"
            }
          }
        }.not_to change(User, :count)
      end

      it "does not create additional Company" do
        initial_count = Company.count
        post user_registration_path, params: {
          user: {
            email: "existing@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
        expect(Company.count).to eq(initial_count)
      end
    end
  end

  describe "Devise Session Management" do
    let(:user) { create(:user) }

    describe "POST /users/sign_in" do
      it "signs in user with valid credentials" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: user.password
          }
        }
        expect(response).to redirect_to(dashboard_url)
      end

      it "does not sign in with invalid credentials" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: "wrong_password"
          }
        }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    describe "DELETE /users/sign_out" do
      before { sign_in user }

      it "signs out user" do
        delete destroy_user_session_path
        expect(response).to redirect_to(root_url)
      end

      it "clears user session" do
        delete destroy_user_session_path
        follow_redirect!
        expect(controller.current_user).to be_nil
      end
    end
  end

  describe "User Data Isolation on Signup" do
    let(:user1_params) do
      {
        user: {
          email: "user1@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    let(:user2_params) do
      {
        user: {
          email: "user2@example.com",
          password: "password456",
          password_confirmation: "password456"
        }
      }
    end

    it "creates separate companies for different users" do
      post user_registration_path, params: user1_params
      user1 = User.find_by(email: "user1@example.com")
      
      post user_registration_path, params: user2_params
      user2 = User.find_by(email: "user2@example.com")
      
      expect(user1.company).not_to eq(user2.company)
    end

    it "ensures each user only sees their own company" do
      post user_registration_path, params: user1_params
      user1 = User.find_by(email: "user1@example.com")
      company1 = user1.company

      post user_registration_path, params: user2_params
      user2 = User.find_by(email: "user2@example.com")

      sign_in user2
      get companies_path
      expect(assigns(:companies)).not_to include(company1)
    end
  end
end
