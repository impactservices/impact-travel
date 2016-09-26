require "spec_helper"

describe ImpactTravel::SearchesController do
  routes { ImpactTravel::Engine.routes }

  describe "#create" do
    context "with valid search information" do
      it "creates a new search" do
        sign_in_as(build(:subscriber))
        search = build(:search)

        stub_search_create_api(search.attributes)
        post :create, search: attributes_for(:search)

        expect(flash.notice).to eq(I18n.t("search.create.success"))
        expect(response).to redirect_to(search_path(search.search_id))
      end
    end

    context "with invalid search information" do
      it "does not create any search" do
        sign_in_as(build(:subscriber))

        stub_unprocessable_dn_api_request("searches")
        post(:create, search: attributes_for(:search, location_id: nil))

        expect(response).to redirect_to(home_path)
        expect(flash.notice).to eq(I18n.t("search.create.errors"))
      end
    end
  end

  describe "#show" do
    context "with valid search id" do
      it "shows the results loading page" do
        sign_in_as(build(:subscriber))
        search = build(:search)

        stub_search_find_api(search.search_id)
        get :show, id: search.search_id

        expect(response.status).to eq(200)
        expect(response).to render_template(layout: "impact_travel/loading")
      end
    end

    context "with invalid search id" do
      it "redirect to home_path" do
        sign_in_as(build(:subscriber))
        search_id = "invalid_id"
        stub_unauthorized_dn_api_reqeust(
          ["searches", search_id].join("/"),
        )

        get :show, id: search_id

        expect(response).to redirect_to(home_path)
        expect(flash.notice).to eq(I18n.t("search.show.error"))
      end
    end
  end

  def sign_in_as(subscriber)
    session[:auth_token] = subscriber.token
  end
end
