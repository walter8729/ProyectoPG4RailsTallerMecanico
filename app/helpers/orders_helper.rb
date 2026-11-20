module OrdersHelper
  def order_status_badge(status)
    case status
    when "Pendiente"
      content_tag(:span, status, style: "background: #fef3c7; color: #92400e; padding: 4px 10px; border-radius: 9999px; font-size: 0.8rem; font-weight: 600; display: inline-block;")
    when "En Proceso"
      content_tag(:span, status, style: "background: #dbeafe; color: #1e40af; padding: 4px 10px; border-radius: 9999px; font-size: 0.8rem; font-weight: 600; display: inline-block;")
    when "Completada"
      content_tag(:span, status, style: "background: #dcfce7; color: #166534; padding: 4px 10px; border-radius: 9999px; font-size: 0.8rem; font-weight: 600; display: inline-block;")
    else
      content_tag(:span, status, style: "background: #f3f4f6; color: #374151; padding: 4px 10px; border-radius: 9999px; font-size: 0.8rem; font-weight: 600; display: inline-block;")
    end
  end
end
