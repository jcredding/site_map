SiteMap.define do

  view :welcome__index do
    label "Welcome"
    visible true
    url '/'
  end

  group :admin do
    label 'Admin'

    view :phases_index
  end

  # GET     INDEX     :<resource>_index
  # GET     NEW       :<resource>_index
  # POST    CREATE    :<resource>_index
  # GET     SHOW      :<resource>_show
  # GET     EDIT      :<resource>_edit
  # PUT     UPDATE    :<resource>_edit
  # DELETE  DESTROY   :<resource>_show

  # /admins/purchase/approval_paths
  # /admins/purchase/roles
  # /admins/reimbursement/phases
  # /admins/reimbursement/validators
=begin
  group :admin do
    label 'Admin'

    group :purchases do
      label 'Purchase'

      resources :phases do
        collection :index, :new, :create do
          label "Phases"
        end
        member :update, :destroy do
          label "Phase {{id}} - {{name}}"
        end
      end
      # resources :phases
      # ==
      # collection :phases do
      #   member :phases
      # end
      # ==
      # collection :phases, :index do
      #   member :phases, :show
      #   member :phases, :edit
      # end
      # ==
      # view :phases_index do
      #   view :phases_show
      #   proxy :phases_destroy, :as => :phases_show
      #   view :phases_edit
      #   proxy :phases_update, :as => :phases_edit
      # end
      # proxy :phases_new, :as => :phases_index
      # proxy :phases_create, :as => :phases_index
      collection :approval_paths
      collection :roles
    end

  end
=end
  # SiteMap[:admin_purchases_phases_index]
  #   Node {
  #     index: 'admin_purchases_phases_index'
  #     label: 'Phases'
  #
  #   }

  # /purchases
  # /purchases/:id
  # /purchases/:id/history => changes


  # /reimbursements
  # /reimbursements/:id

end
