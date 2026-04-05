from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
import time
import os


def generate_invoice(items,total):

    filename = f"invoices/invoice_{int(time.time())}.pdf"

    c = canvas.Canvas(filename,pagesize=letter)

    y = 750

    # PHARMACY INFO

    c.setFont("Helvetica-Bold",16)
    c.drawString(200,y,"UMAR PHARMACY")

    y -= 20
    c.setFont("Helvetica",10)
    c.drawString(200,y,"Main Market Road")

    y -= 15
    c.drawString(200,y,"Phone: 9876543210")

    y -= 15
    c.drawString(200,y,"GST: 22AAAAA0000A1Z5")


    # BILL INFO

    y -= 40

    c.drawString(50,y,"Customer: Walk-in")

    y -= 15
    c.drawString(50,y,"Date: "+time.strftime("%d-%m-%Y %H:%M"))


    # TABLE HEADER

    y -= 30

    c.setFont("Helvetica-Bold",11)

    c.drawString(50,y,"Medicine")
    c.drawString(250,y,"Qty")
    c.drawString(300,y,"Price")
    c.drawString(370,y,"Total")


    c.setFont("Helvetica",10)

    y -= 20

    subtotal = 0

    for item in items:

        line_total = item["price"] * item["quantity"]

        subtotal += line_total

        c.drawString(50,y,item["name"])
        c.drawString(250,y,str(item["quantity"]))
        c.drawString(300,y,str(item["price"]))
        c.drawString(370,y,str(line_total))

        y -= 20


    # GST CALCULATION

    gst = subtotal * 0.12

    cgst = gst / 2
    sgst = gst / 2

    grand_total = subtotal + gst


    y -= 20

    c.drawString(300,y,"Subtotal:")
    c.drawString(380,y,str(round(subtotal,2)))

    y -= 15

    c.drawString(300,y,"CGST (6%):")
    c.drawString(380,y,str(round(cgst,2)))

    y -= 15

    c.drawString(300,y,"SGST (6%):")
    c.drawString(380,y,str(round(sgst,2)))

    y -= 15

    c.setFont("Helvetica-Bold",11)

    c.drawString(300,y,"Grand Total:")
    c.drawString(380,y,str(round(grand_total,2)))


    # FOOTER

    y -= 40

    c.setFont("Helvetica",10)

    c.drawString(200,y,"Thank you for visiting!")


    c.save()

    return os.path.basename(filename)