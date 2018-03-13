class EffectsController < ApplicationController
  def index
    @effects = rule.effects.page params[:page]
  end

  def new
    @effect = rule.effects.new
  end

  def create
    @effect = rule.effects.new(effect_params)

    if @effect.save
      redirect_to rule_effects_path(rule), notice: 'Action added'
    else
      render :new
    end
  end

  def edit
    effect
  end

  def update
    if effect.update(effect_params)
      redirect_to rule_effects_path(effect.rule), notice: 'Action updated'
    else
      render :edit
    end
  end

  def destroy
    effect.destroy
    redirect_to rule_effects_path(effect.rule), notice: 'Action deleted.'
  end

  private

  helper_method :rule
  def rule
    @rule ||= Rule.by_user(current_user).find(params[:rule_id])
  end

  def effect
    @effect ||= Effect.by_user(current_user).find(params[:id])
  end

  def effect_params
    params.require(:effect).permit(:type, :value)
  end
end
