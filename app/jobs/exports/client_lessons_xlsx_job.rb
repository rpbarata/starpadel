# frozen_string_literal: true

module Exports
  class ClientLessonsXlsxJob < ApplicationJob
    queue_as :exports

    def perform(client_lesson_ids)
      client_lessons =
        ClientLesson.includes([:client, :coach_admin, credited_lesson: [:lessons_type]])
          .where(id: client_lesson_ids)
          .order(:start_time)

      Dir.mkdir("tmp/exports") unless File.exist?("tmp/exports")

      date = Time.current.strftime("%Y%m%d%H%M")
      filename = "tmp/exports/aulas_#{date}.xlsx"

      workbook = WriteXLSX.new(filename, { "constant_memory": true })
      worksheet = workbook.add_worksheet

      # Format cells width
      worksheet.set_column("A:A", 17)
      worksheet.set_column("B:B", 17)
      worksheet.set_column("C:C", 20)
      worksheet.set_column("D:D", 40)
      worksheet.set_column("E:E", 25)
      worksheet.set_column("F:F", 20)

      client_lesson_header.each_with_index do |col, i|
        worksheet.write(0, i, col,
          workbook.add_format({ "bg_color": "#C5C5C5", "bold": "1", "align": "center", "border": 1 }))
      end

      client_lessons.each_with_index do |client_lesson, row|
        client_lesson_line(client_lesson).each_with_index do |text, col|
          if text.respond_to?(:strftime)
            worksheet.write_date_time(row + 1, col, text.strftime("%d/%m/%Y %H:%M"),
              workbook.add_format({ "border": 1 }))
          else
            worksheet.write(row + 1, col, text, workbook.add_format({ "border": 1 }))
          end
        end
      end

      workbook.close
      GC.start
      filename
    end

    private

    def client_lesson_header
      [
        "HORA INÍCIO",
        "HORA FIM",
        "DURAÇÃO (horas)",
        "TURMA",
        "TIPO DE AULA",
        "TREINADOR",
      ]
    end

    def client_lesson_line(client_lesson)
      line = [
        client_lesson.start_time,
        client_lesson.end_time,
        client_lesson.duration,
        client_lesson.client&.name,
        client_lesson.credited_lesson.name,
        client_lesson.coach_admin&.username,
      ]

      line
    end
  end
end
