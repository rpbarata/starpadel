import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';
import bootstrapPlugin from '@fullcalendar/bootstrap';

$(document).on('turbolinks:load', function () {
  let calendarEl = document.getElementById('calendar');

  let calendar = new Calendar(calendarEl, {
    plugins: [dayGridPlugin, timeGridPlugin, listPlugin, bootstrapPlugin, dayGridPlugin],
    initialView: 'timeGridWeek',
    themeSystem: 'bootstrap',
    aspectRatio: 1.8,
    nowIndicator: true,
    locale: 'pt-PT',
    timezone: 'local',
    buttonText: {
      today: 'Hoje',
      month: 'Mês',
      week: 'Semana',
      day: 'Dia',
      list: 'Eventos'
    },
    headerToolbar: {
      left: 'prev,next today',
      center: 'title',
      right: 'dayGridMonth,timeGridWeek,listWeek'
    },
    events: '/clients/calendar.json',
  });

  calendar.render();

  $('.fc-toolbar.fc-header-toolbar').addClass('row col-lg-12');
});