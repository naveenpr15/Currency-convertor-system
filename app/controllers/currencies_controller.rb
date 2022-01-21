class CurrenciesController < ApplicationController
  def index
    @currencies = Currency.all.limit(10)
    render json: @currencies
  end

  def show
    @currency = Currency.find_by_id(params[:id])
    if @currency.present?
      render json: @currency
    else
      render json: {status: 'FAILED', message: 'NOT FOUND', data: @currency}
    end
  end

  def convert
    @result = Currency.convert(params[:from_currency],params[:to_currency],params[:value])
    if @result.present?
      render json: {from_currency: params[:from_currency], to_currency: params[:to_currency], value: params[:value], result: @result}
    else
      render json: {status: 'FAILED', message: 'UNVALID FROM_CURRENCY OR TWO CURRENCY', data: @currency}
    end
  end

end
