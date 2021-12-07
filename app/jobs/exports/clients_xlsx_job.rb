# frozen_string_literal: true

module Exports
  class ClientsXlsxJob < ApplicationJob
    def perform(client_ids)
      clients = Client.where(id: client_ids).order(name: :asc)

      Dir.mkdir("tmp/exports") unless File.exist?("tmp/exports")

      date = Time.current.strftime("%Y%m%d%H%M")
      filename = "tmp/exports/clients_#{date}.xlsx"

      workbook = WriteXLSX.new(filename, { "constant_memory": true })
      worksheet = workbook.add_worksheet

      birth_date_col_index = nil
      operation_header.each_with_index do |col, i|
        worksheet.write(0, i, col)
        birth_date_col_index = i if col == "Data de Nascimento"
      end

      clients.each_with_index do |client, row|
        client_line(client).each_with_index do |text, col|
          if col == birth_date_col_index && !text.nil?
            worksheet.write_date_time(row + 1, col, text.strftime("%d/%m/%Y"))
          elsif text.respond_to?(:strftime)
            worksheet.write_date_time(row + 1, col, text.iso8601)
          else
            worksheet.write(row + 1, col, text)
          end
        end
      end

      workbook.close
      GC.start
      filename
    end

    private

    def operation_header
      [
        "Nome",
        "Email",
        "Número de Telemóvel",
        "Morada",
        "Número de Sócio Star Padel",
        "Sócio Master?",
        "Número de Sócio FPP",
        "Nº de CC",
        "NIF",
        "Data de Nascimento",
        "Adulto?",
      ]
    end

    def client_line(client)
      line = [
        client.name,
        client.email,
        client.phone_number,
        client.address,
        client.member_id,
        client.is_master_member ? I18n.t("boolean.true") : I18n.t("boolean.false"),
        client.fpp_id,
        client.identification_number,
        client.nif,
        client.birth_date,
        client.birth_date.present? ? I18n.t("boolean.#{client.adult?}") : nil,
      ]

      line
    end
  end
end
