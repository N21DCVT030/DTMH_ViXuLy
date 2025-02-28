using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO.Ports;
using ZedGraph;


namespace vixuli
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
    
        }
        string[] Baudrate = { "1200", "2400", "4800", "9600", "19200", "38400", "115200" };
        private void Form1_Load(object sender, EventArgs e)
        {
            string[] cboCom = SerialPort.GetPortNames();
            cboComPort.Items.AddRange(cboCom);
            cboBaudrate.Items.AddRange(Baudrate);

            GraphPane bieudo = Bieudonhietdo.GraphPane;
            bieudo.Title.Text = "Biểu đồ cập nhật nhiệt độ";
            bieudo.YAxis.Title.Text = "Nhiệt độ";
            bieudo.XAxis.Title.Text = "Thời gian";
            RollingPointPairList list = new RollingPointPairList(600000);
            LineItem duong = bieudo.AddCurve("Nhiệt độ", list, Color.Blue, SymbolType.Circle);

            bieudo.XAxis.Scale.Min = 0;
            bieudo.XAxis.Scale.Max = 100;
            bieudo.XAxis.Scale.MinorStep = 0;
            bieudo.XAxis.Scale.MajorStep = 1;

            bieudo.YAxis.Scale.Min = 0;
            bieudo.YAxis.Scale.Max = 50;
            bieudo.YAxis.Scale.MinorStep = 0;
            bieudo.YAxis.Scale.MajorStep = 1;
            Bieudonhietdo.AxisChange();

        }

        int tong = 0;
        public void draw (double line)
        {
            LineItem duong = Bieudonhietdo.GraphPane.CurveList[0] as LineItem;
            if (duong == null)
            {
                return;
            }
            IPointListEdit list = duong.Points as IPointListEdit;
            if (list == null)
            {
                return;
            }
            list.Add(tong, line);
            Bieudonhietdo.AxisChange();
            Bieudonhietdo.Invalidate();
            tong += 2;
        }

       
        private void serCOM_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            string dulieu = "";
            dulieu += serCOM.ReadLine();
            dulieu = dulieu.Trim(); 
            if (dulieu.Length > 0)
            {
                if (int.TryParse(dulieu, out int tong))
                {
                    Invoke(new MethodInvoker(() => draw(Convert.ToDouble(dulieu))));
                    Invoke(new MethodInvoker(() => listBox1.Items.Add(dulieu)));                   
                }
                else
                {
                    string kitu = dulieu.Substring(0, 2);
                    Invoke(new MethodInvoker(() => listBox2.Items.Add(kitu)));
                }
            }
        }

        private void butConnect_Click(object sender, EventArgs e)
        {
            if (cboComPort.Text == "")
            {
                MessageBox.Show("Bạn chưa chọn cổng COM", "Thông Báo");
            }
            else if (cboBaudrate.Text == "")
            {
                MessageBox.Show("Bạn chưa chọn tốc độ BAUDRATE", "Thông Báo");
            }
            if (serCOM.IsOpen)
            {
                serCOM.Close();
                butConnect.Text = "KẾT NỐI";
            }
            else if (serCOM.IsOpen == false)
            {
                serCOM.PortName = cboComPort.Text;
                serCOM.BaudRate = int.Parse(cboBaudrate.Text);
                serCOM.Open();
                butConnect.Text = "NGẮT KẾT NỐI";
            }
        }

        private void butExit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void butMoDen_Click(object sender, EventArgs e)
        {
            try
            {
                serCOM.Write("9");
                butMoDen.Text = "RUN";
            }
            catch 
            {
                MessageBox.Show("Kiểm tra lại kết nối", "Thông báo");
            }
        }

        bool led1 = true;
        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                if (butMoDen.Text == "RUN")
                {
                    if (led1 == true)
                    {
                        serCOM.Write("1");
                        button1.Text = "ON";
                        led1 = false;
                    }
                    else
                    {
                        serCOM.Write("q");
                        button1.Text = "OFF";
                        led1 = true;
                    }
                }
            }
            catch
            {
                MessageBox.Show("Kiểm tra lại kết nối", "Thông báo");
            }
        }

        bool led2 = true;
        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                if (butMoDen.Text == "RUN")
                {
                    if (led2 == true)
                    {
                        serCOM.Write("2");
                        button2.Text = "ON";
                        led2 = false;
                    }
                    else
                    {
                        serCOM.Write("w");
                        button2.Text = "OFF";
                        led2 = true;
                    }
                }
            }
            catch
            {
                MessageBox.Show("Kiểm tra lại kết nối", "Thông báo");
            }
        }

        bool led3 = true;
        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                if (butMoDen.Text == "RUN")
                {
                    if (led3 == true)
                    {
                        serCOM.Write("3");
                        button3.Text = "ON";
                        led3 = false;
                    }
                    else
                    {
                        serCOM.Write("e");
                        button3.Text = "OFF";
                        led3 = true;
                    }
                }
            }
            catch
            {
                MessageBox.Show("Kiểm tra lại kết nối", "Thông báo");
            }
        }

        bool led4 = true;
        private void button4_Click(object sender, EventArgs e)
        {
            try
            {
                if (butMoDen.Text == "RUN")
                {
                    if (led4 == true)
                    {
                        serCOM.Write("4");
                        button4.Text = "ON";
                        led4 = false;
                    }
                    else
                    {
                        serCOM.Write("r");
                        button4.Text = "OFF";
                        led4 = true;
                    }
                }
            }
            catch
            {
                MessageBox.Show("Kiểm tra lại kết nối", "Thông báo");
            }
        }

        bool led5 = true;
        private void button5_Click(object sender, EventArgs e)
        {
            try
            {
                if (butMoDen.Text == "RUN")
                {
                    if (led5 == true)
                    {
                        serCOM.Write("5");
                        button5.Text = "ON";
                        led5 = false;
                    }
                    else
                    {
                        serCOM.Write("t");
                        button5.Text = "OFF";
                        led5 = true;
                    }
                }
            }
            catch
            {
                MessageBox.Show("Kiểm tra lại kết nối", "Thông báo");
            }
        }

        bool led6 = true;
        private void button6_Click(object sender, EventArgs e)
        {
            try
            {
                if (butMoDen.Text == "RUN")
                {
                    if (led6 == true)
                    {
                        serCOM.Write("6");
                        button6.Text = "ON";
                        led6 = false;
                    }
                    else
                    {
                        serCOM.Write("y");
                        button6.Text = "OFF";
                        led6 = true;
                    }
                }
            }
            catch
            {
                MessageBox.Show("Kiểm tra lại kết nối", "Thông báo");
            }
        }

        bool led7 = true;
        private void button7_Click(object sender, EventArgs e)
        {
            try
            {
                if (butMoDen.Text == "RUN")
                {
                    if (led7 == true)
                    {
                        serCOM.Write("7");
                        button7.Text = "ON";
                        led7 = false;
                    }
                    else
                    {
                        serCOM.Write("u");
                        button7.Text = "OFF";
                        led7 = true;
                    }
                }
            }
            catch
            {
                MessageBox.Show("Kiểm tra lại kết nối", "Thông báo");
            }
        }

        bool led8 = true;
        private void button8_Click(object sender, EventArgs e)
        {
            try
            {
                if (butMoDen.Text == "RUN")
                {
                    if (led8 == true)
                    {
                        serCOM.Write("8");
                        button8.Text = "ON";
                        led8 = false;
                    }
                    else
                    {
                        serCOM.Write("i");
                        button8.Text = "OFF";
                        led8 = true;
                    }
                }
            }
            catch
            {
                MessageBox.Show("Kiểm tra lại kết nối", "Thông báo");
            }
        }

        private void button9_Click(object sender, EventArgs e)
        {
            String dulieu = txtSend.Text;
            serCOM.Write(dulieu);
        }
    }
}
