class AskController < ApplicationController

  def index
    @current_locale = I18n.locale
    @criteria_count = TwoCriterium.where(:uses => false).count

    if @criteria_count<1
      redirect_to :controller => 'requests'
    else
      if session[:counter].nil? or session[:counter]==0
        @two_criterias = TwoCriterium.where(:uses => false).order(id: :asc)[0]
        session[:criteria1_id] = @two_criterias["criteria1_id"]
        session[:criteria2_id] = @two_criterias["criteria2_id"]
        @assessments1 = Criterium.find(session[:criteria1_id]).assessments.order(id: :asc)
        @assessments2 = Criterium.find(session[:criteria2_id]).assessments.order(id: :asc)
        session[:assessments1] = @assessments1
        session[:assessments2] = @assessments2
        session[:assessment11_id] = 1
        session[:assessment12_id] = 2
        session[:assessment21_id] = 2
        session[:assessment22_id] = 1
        @assessment11 = @assessments1[session[:assessment11_id]-1]
        @assessment12 = @assessments2[session[:assessment12_id]-1]
        @assessment21 = @assessments1[session[:assessment21_id]-1]
        @assessment22 = @assessments2[session[:assessment22_id]-1]
        session[:counter] = 1
      else
        if session[:counter] <3
          @assessments1 = Criterium.find(session[:criteria1_id]).assessments.order(id: :asc)
          @assessments2 = Criterium.find(session[:criteria2_id]).assessments.order(id: :asc)
          session[:counter] +=1
          if params[:decision] == "assessment1"
            new_ass_arr = change_assessments(session[:assessment11_id], session[:assessment12_id], @assessments1)
            session[:assessment11_id] = new_ass_arr[0]
            session[:assessment12_id] = new_ass_arr[1]
            @assessment11 = @assessments1[session[:assessment11_id]-1]
            @assessment12 = @assessments2[session[:assessment12_id]-1]
            # it was
            @assessment21 = @assessments1[session[:assessment21_id]-1]
            @assessment22 = @assessments2[session[:assessment22_id]-1]
          else
            new_ass_arr = change_assessments(session[:assessment21_id], session[:assessment22_id], @assessments2)
            session[:assessment21_id] = new_ass_arr[0]
            session[:assessment22_id] = new_ass_arr[1]
            @assessment21 = @assessments1[session[:assessment21_id]-1]
            @assessment22 = @assessments2[session[:assessment22_id]-1]
            # it was
            @assessment11 = @assessments1[session[:assessment11_id]-1]
            @assessment12 = @assessments2[session[:assessment12_id]-1]
          end
        else
          @criteria_count = TwoCriterium.where(:uses => false).count - 1
          if @criteria_count < 1
            redirect_to :controller => 'requests'
          else
            TwoCriterium.where(:uses => false).order(id: :asc)[0].update(uses:true)
            session[:counter] = 1
            @two_criterias = TwoCriterium.where(:uses => false).order(id: :asc)[0]
            session[:criteria1_id] = @two_criterias["criteria1_id"]
            session[:criteria2_id] = @two_criterias["criteria2_id"]
            @assessments1 = Criterium.find(session[:criteria1_id]).assessments.order(id: :asc)
            @assessments2 = Criterium.find(session[:criteria2_id]).assessments.order(id: :asc)
            session[:assessments1] = @assessments1
            session[:assessments2] = @assessments2
            session[:assessment11_id] = 1
            session[:assessment12_id] = 2
            session[:assessment21_id] = 2
            session[:assessment22_id] = 1
            @assessment11 = @assessments1[session[:assessment11_id]-1]
            @assessment12 = @assessments2[session[:assessment12_id]-1]
            @assessment21 = @assessments1[session[:assessment21_id]-1]
            @assessment22 = @assessments2[session[:assessment22_id]-1]
          end
        end
      end
    end

  end

  def update_request
    @assessment11_id = session[:assessments1][session[:assessment11_id]-1]["id"]
    @assessment12_id = session[:assessments2][session[:assessment12_id]-1]["id"]
    @assessment21_id = session[:assessments1][session[:assessment21_id]-1]["id"]
    @assessment22_id = session[:assessments2][session[:assessment22_id]-1]["id"]
    @req_ask = Request.new(assessment11_id: @assessment11_id,
                    assessment12_id: @assessment12_id,
                    assessment21_id: @assessment21_id,
                    assessment22_id: @assessment22_id,
                    ans: params[:decision])

    @req_ask = Request.new(assessment11_id: @assessment11_id,assessment12_id: @assessment12_id,assessment21_id: @assessment21_id,assessment22_id: @assessment22_id,ans: params[:decision])
    @req_ask.save
    @decision = ""
    redirect_to ask_url decision: params[:decision]
  end
private
  def request_params
    params.require(:request).permit( :decision)
  end

  def change_assessments(assessmen1_id, assessmen2_id, assessments)
    len = assessments.count
    if assessmen2_id == 1
      if assessmen1_id < len
        assessmen1_id+=1
      else
        x=assessmen1_id
        assessmen1_id = assessmen2_id
        assessmen2_id = x
      end
    else
      if assessmen2_id < len
        assessmen2_id+=1
      else
        x=assessmen1_id
        assessmen1_id = assessmen2_id
        assessmen2_id = x
      end
    end
    [assessmen1_id, assessmen2_id]
  end
end
