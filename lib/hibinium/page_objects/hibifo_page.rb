require 'page-object'

module Hibinium
  module PageObjects
    class HibifoPage
      include PageObject

      # 日付
      text_field(:date, :name => 'date')
      # 勤務時間 - 開始
      text_field(:start_time, :id => 'start_time')
      # 勤務時間 - 終了
      text_field(:end_time, :name => 'end_time')
      # 出勤, 欠勤, 有給／代休
      select_list(:work_type, :name => 'work_type')
      # 休憩
      text_field(:break_time, :name => 'break_time')

      # 作業時間
      div(:workTimeBox, :id => 'workTimeBox')

      # report.details
      # TODO 報告詳細

      # add_detail
      button(:add_detail, :value => '+追加')


      # 今日の振り返り(所感 / 思うところ)
      text_area(:comment, :name => 'comment')
      # 得た知識・経験
      text_area(:experience, :name => 'experience')
      # 問題や課題 / 懸念事項
      text_area(:remarks, :name => 'remarks')
      # その他 / 提案事項など
      text_area(:other, :name => 'other')


      # 一時保存
      button(:temporary_save, :value => '一時保存')
      # 保存
      button(:save, :value => ' 保 存 ')

    end
  end
end
