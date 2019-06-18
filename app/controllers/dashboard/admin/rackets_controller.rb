class Dashboard::Admin::RacketsController < Dashboard::Admin::AdminController
  def index
    @rackets = @paginate = Racket.paginate(:page => params[:page])
  end

  def new
    @racket = Racket.new
  end

  def edit
    @racket = Racket.find(params[:id])
  end

  def create
    @racket = Racket.new(racket_params)
    if @racket.save!
      redirect_to :action => :index , notice: '球拍資料成功新增！！！'
    else
      render :new
    end
  end

  def update
    @racket = Racket.find(params[:id])
    @racket.update(racket_params)
    redirect_to :action => :index , notice: '球拍資料成功更新！！！'
  end

  def destroy
    @racket = Racket.find(params[:id])
    @racket.destroy
    redirect_to :action => :index , notice: '球拍資料已刪除！！！'
  end

  private

  def racket_params
    params.require(:racket).permit!
  end

end
