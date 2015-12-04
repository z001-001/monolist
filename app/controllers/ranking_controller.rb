class RankingController < ApplicationController
  def have
    rank_counts =  Have.group(:item_id).order("count_item_id DESC").limit(10).count(:item_id)
    make_rank_list(rank_counts)
  end

  def want
    rank_counts =  Want.group(:item_id).order("count_item_id DESC").limit(10).count(:item_id)
    make_rank_list(rank_counts)
  end

  private
  def make_rank_list(rank_counts)
    # eager load
    Ownership.eager_load(:item).where(item: {id: rank_counts.keys})

    # 同じcountのItemについて同順位に並ぶようにする
    # 1位 10点
    # 2位  9点
    # 2位  9点
    # 4位  7点
    @rank_list = []
    prev_rank = 1
    prev_count = -1
    i = 1
    rank_counts.each do |id, count|
      if count == prev_count
        cur_rank = prev_rank
      else
        prev_rank = cur_rank = i
        prev_count = count
      end
      @rank_list << [cur_rank, count, Item.find(id)]
      i += 1
    end
  end

end
