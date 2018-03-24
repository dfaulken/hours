class ShiftsController < ApplicationController
  before_action :set_shift, only: [:update, :destroy]

  # GET /shifts
  # GET /shifts.json
  def index
    @date = Date.parse(params[:date]) rescue Date.today
    @date = @date.beginning_of_week(:sunday)
    @dates = (@date..(@date + 6.days))
    @shifts = Shift.in_week_beginning(@date).order(:start)
    @chunk_range = (@shifts.earliest_start - 4)..(@shifts.latest_end + 4)
    @chunks = @shifts.chunkify
    @lengths = @shifts.lengths
  end

  # POST /shifts
  # POST /shifts.json
  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      notice = 'Shift was successfully created.'
    else
      alert = @shift.errors.full_messages.to_sentence
    end
    redirect_to shifts_path(date: @shift.start.to_date),
      notice: notice, alert: alert
  end

  # PATCH/PUT /shifts/1
  # PATCH/PUT /shifts/1.json
  def update
    @shift.assign_attributes shift_params
    if @shift.save
      notice = 'Shift was successfully saved.'
    else
      alert = @shift.errors.full_messages.to_sentence
    end
    redirect_to shifts_path(date: @shift.start.to_date),
      notice: notice, alert: alert
  end

  # DELETE /shifts/1
  # DELETE /shifts/1.json
  def destroy
    @shift.destroy
    respond_to do |format|
      format.html { redirect_to shifts_url(date: @shift.start.to_date),
                    notice: 'Shift was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shift_params
      params.require(:shift).permit(:start, :length, :mbta)
    end
end
