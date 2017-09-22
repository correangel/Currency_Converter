class BuysController < ApplicationController
  before_action :set_buy, only: [:show, :edit, :update, :destroy]
  before_action :set_select_information, only: [:edit, :new]
  before_action :set_all_price_buy, only: [:index, :show, :create, :update, :edit, :new]
  # GET /buys
  # GET /buys.json
  def index
    @buys = Buy.all
  end

  # GET /buys/1
  # GET /buys/1.json
  def show
  end

  # GET /buys/new
  def new
    @buy = Buy.new
  end

  # GET /buys/1/edit
  def edit
  end

  # POST /buys
  # POST /buys.json
  def create
    # calculando taxas + percentual
    out_value = calculation_buy

    @buy = Buy.new(buy_params)
    @buy.value_out = out_value

    respond_to do |format|
      if @buy.save
        format.html { redirect_to @buy, notice: 'Compra Realizada com sucesso!' }
        format.json { render :show, status: :created, location: @buy }
      else
        format.html { render :new }
        format.json { render json: @buy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buys/1
  # PATCH/PUT /buys/1.json
  def update
    # calculando taxas + percentual
    out_value = calculation_buy
    @buy.value_out = out_value

    respond_to do |format|
      if @buy.update(buy_params) 

        format.html { redirect_to @buy, notice: 'Compra alterada com sucesso!' }
        format.json { render :show, status: :ok, location: @buy }
      else
        format.html { render :edit }
        format.json { render json: @buy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buys/1
  # DELETE /buys/1.json
  def destroy
    @buy.destroy
    respond_to do |format|
      format.html { redirect_to buys_url, notice: 'Compra apagada com sucesso!' }
      format.json { head :no_content }
    end
  end

  private
    # % da Compra
    Value_in_buy = 1.01741
    # % do Imposto
    Value_tax = 1.011

    def set_all_price_buy
      @currencies = Currency.all
      @currencies.each do |currency|
        currency.price *= Value_in_buy
        currency.price *= Value_tax
      end
    end


    def set_select_information
      @users = User.all
      @customers = Customer.all
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_buy
      @buy = Buy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def buy_params
      params.require(:buy).permit(:user_id, :customer_id, :value_input, :currency_input_id, :currency_out_id)
    end


    def calculation_buy 
      value_input = params[:buy][:value_input]
      currency_input_id = params[:buy][:currency_input_id]
      currency_out_id = params[:buy][:currency_out_id]


      currency_input = @currencies.find(currency_input_id).price.to_f
      currency_output = @currencies.find(currency_out_id).price.to_f 

      currency_output *= Value_in_buy
      currency_output *= Value_tax

      out_value = (value_input.to_f * currency_input) / currency_output
      out_value
    end
end
