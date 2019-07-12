class RacketsController < ApplicationController

  def index
    @rackets = @paginate = Racket.paginate(:page =>params[:page])
  end

  def price_sort_decs
    @rackets = @paginate = Racket.order(price: :desc).paginate(:page => params[:page])
  end

  def price_sort_acs
    @rackets = @paginate = Racket.order(price: :asc).paginate(:page => params[:page])
  end

  def label_sort_decs
    @rackets = @paginate = Racket.order(label: :desc).paginate(:page => params[:page])
  end

  def label_sort_acs
    @rackets = @paginate = Racket.order(label: :asc).paginate(:page => params[:page])
  end

  def findracket
    found_racket = []
    Racket.find_each do |r|
      if r.lunched == 1 && (r.name.include?(params[:keyword]) || r.label.include?(params[:keyword]))
        found_racket << r
      end
    end

    @rackets = @paginate = found_racket.paginate(:page => params[:page])

  end
end
