class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.all
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)

    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_all
    @requests = Request.all.destroy_all
    @two_criterias = TwoCriterium.where(:uses => true).update_all(uses: false)
    session[:counter]=0
    respond_to do |format|
      format.html { redirect_to ask_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def epsh
    @requests = Request.all.order(id: :asc)
    @len_criteria = Criterium.all.count
    @len_assessment = Criterium.all.first.assessments.count
    it=0
    arr_epsh_it=-1
    @arr_epsh = []
    while it < @requests.count-1
      start_ass1 = max_id_ass_by_crit(@requests[it].assessment11_id)
      start_ass2 = max_id_ass_by_crit(@requests[it].assessment12_id)
      @arr_epsh.push([start_ass1,start_ass2])
      arr_epsh_it+=1
      for i in 0..@len_assessment-1
        @ch = get_change_req(@requests[it])
        @arr_epsh[arr_epsh_it].push(@ch)
        it+=1
      end
      arr_asss1 = Assessment.find(start_ass1).criteria.assessments.ids
      arr_asss2 = Assessment.find(start_ass2).criteria.assessments.ids
      arr_asss = arr_asss1 | arr_asss2
      adding_item = arr_asss - @arr_epsh[arr_epsh_it]
      @arr_epsh[arr_epsh_it] = @arr_epsh[arr_epsh_it] + adding_item
    end
    # Делаем ЕДИНУЮ ШКАЛУ @eshik
    @eshik=[]
    @arr_epsh = @arr_epsh.sort_by { |arr | -arr.count }
    while @arr_epsh[0].count > 0
      item = @arr_epsh[0][0]
      @eshik.push(item)
      @arr_epsh.map{|arr| arr.delete(item)}
      @arr_epsh = @arr_epsh.sort_by { |arr | -arr.count }
    end


    # Проставляем ранги у оценок
    @assessments = Assessment.all
    for i in 0..@len_assessment-1
      ass_id = @eshik[i]
      Assessment.find(ass_id).update(rang: @assessments.count)
    end
    for i in @len_assessment..@eshik.count-1
      ass_id = @eshik[i]
      Assessment.find(ass_id).update(rang: @assessments.count-i)
    end

    # Обновить все оценки по НИРам
    @nirs = Nir.all
    for @nir in @nirs
      #  [@nir.assessment1.rang, @nir.assessment2.rang, @nir.assessment3.rang].sum
      @nir.update(v: (Math.sqrt(@nir.assessment1.rang**2 + @nir.assessment2.rang**2 + @nir.assessment3.rang**2)* 100).to_i.to_f / 100 )
    end
    # Редирект на показ оценок и их рангов
    respond_to do |format|
      format.html { redirect_to assessments_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:assessment11_id, :assessment12_id, :assessment21_id, :assessment22_id, :ans)
    end

    def max_id_ass_by_crit(assessment_id)
      max_id = Assessment.find(assessment_id).criteria.assessments.order(id: :asc).first.id
      max_id
    end

    def get_change_req(request)
      id = request.id
      ans = request.ans
      ass11_id = request.assessment11_id
      ass12_id = request.assessment12_id
      ass21_id = request.assessment21_id
      ass22_id = request.assessment22_id
      a_ass_start = max_id_ass_by_crit(ass11_id)
      b_ass_start = max_id_ass_by_crit(ass12_id)
      if ans == "assessment1"
        change = ass11_id > a_ass_start ? ass11_id : ass12_id
      elsif ans == "assessment2"
        change = ass21_id > a_ass_start ? ass21_id : ass22_id
      else
        change = ass11_id > a_ass_start ? ass11_id : ass12_id
      end
      change
    end


end
