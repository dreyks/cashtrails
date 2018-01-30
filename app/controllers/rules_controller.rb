class RulesController < ApplicationController
  def index
    @rules = importer.rules.page params[:page]
  end

  def new
    @rule = importer.rules.new
  end

  def create
    @rule = importer.rules.new(rule_params)

    if @rule.save
      redirect_to importer_rules_path(importer), notice: 'Rule added'
    else
      render :new
    end
  end

  def edit
    @rule = Rule.by_user(current_user).find(params[:id])
  end

  def update
    @rule = Rule.by_user(current_user).find(params[:id])

    if @rule.update(rule_params)
      redirect_to importer_rules_path(@rule.importer), notice: 'Rule updated'
    else
      render :edit
    end
  end

  def destroy
    rule = Rule.by_user(current_user).find(params[:id])
    rule.destroy
    redirect_to importer_rules_url(rule.importer), notice: 'Rule deleted.'
  end
  private

  def importer
    @importer ||= current_user.importers.find(params[:importer_id])
  end

  def rule_params
    params.require(:rule).permit(:trigger)
  end
end
