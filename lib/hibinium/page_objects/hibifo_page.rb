require 'page-object'
require 'hibinium/page_objects/report_edit_rows'

module Hibinium
  module PageObjects
    class HibifoPage
      include PageObject

      # 日付
      text_field(:date, name: 'date')
      # 勤務時間 - 開始
      text_field(:start_time, id: 'start_time')
      # 勤務時間 - 終了
      text_field(:end_time, name: 'end_time')
      # 出勤, 欠勤, 有給／代休
      select_list(:work_type, name: 'work_type')
      # 休憩
      text_field(:break_time, name: 'break_time')

      # 作業時間
      div(:workTimeBox, id: 'workTimeBox')

      # add_detail 2行追加される
      link(:add_detail, text: '+追加')


      # 今日の振り返り(所感 / 思うところ)
      text_area(:comment, name: 'comment')
      # 得た知識・経験
      text_area(:experience, name: 'experience')
      # 問題や課題 / 懸念事項
      text_area(:remarks, name: 'remarks')
      # その他 / 提案事項など
      text_area(:other, name: 'other')


      # 一時保存
      button(:temporary_save_btn, value: '一時保存')
      # 保存
      button(:save_btn, value: ' 保 存 ')

      # 削除
      link(:delete_link, text: '削除')

      def initialize(root)
        super(root)
      end

      # 指定した日の日々報入力ページを開いて返す。
      # @param date
      #   yyyy-mm-dd
      # @return HibifoPage.new
      def page_to_specified_date(date)
        @browser.get "#{Hibifo_URL}/#{date}"
        sleep 2 # ページがjavascriptで初期化されるのを待つ
        HibifoPage.new(@browser)
      end

      # 一時保存する。
      def temporary_save
        temporary_save_btn
        sleep 5 #TODO:保存されるのを検知してスピードアップ
      end
      # 削除する
      def delete
        delete_link
        sleep 0.5
        confirm = @browser.switch_to.alert
        confirm.accept
        sleep 5 #TODO:削除完了したのを検知してスピードアップ
      end

      # 詳細入力レコードを取得。
      # ReportEditRowsはEnumerable*っぽい*クラス。
      def report_edit_rows
        ReportEditRows.new(@browser)
      end

    end
  end
end
