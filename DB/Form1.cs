using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DB
{
    public partial class Form1 : Form
    {

        private SqlConnection conn = null;
        private SqlDataReader reader = null;
        private BindingSource bindingSource1 = new BindingSource();
        private SqlDataAdapter dataAdapter = new SqlDataAdapter();
        string selectedDB;
        string selectedTB;
        int tries = 2;
        String connectionString =
            "Data Source=sql5028.mywindowshosting.com; " +
         "Initial Catalog=DB_A12AC1_db94; " +
         "User ID=DB_A12AC1_db94_admin; " +
         "Password=db12345678";

        public Form1()
        {
            InitializeComponent();
            this.FormClosing += Form1_FormClosing;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            tabPage2.Enabled = false;
            tabPage3.Enabled = false;
            tabPage4.Enabled = false;
            tabPage5.Enabled = false;
            ConnectSQL();
        }


        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            Disconnect();
        }

        private void Disconnect()
        {
            conn.Close();
        }

        private void ConnectSQL()
        {
            conn = new SqlConnection(connectionString);
            try
            {
                conn.Open();
                MessageBox.Show("Connection Open ! ");

            }
            catch (Exception ex)
            {
                if (tries > 0)
                {
                    tries--;
                    ConnectSQL();
                }
                else
                {
                    MessageBox.Show("Can not open connection ! " + ex.Message);
                    Console.WriteLine(ex.Message);
                    this.Close();
                }
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            pictureBox1.Visible = true;
            panel1.Visible = false;
            SqlCommand selectdatabase = new SqlCommand("Select name from sys.databases;", conn);
            reader = selectdatabase.ExecuteReader();
            List<Button> buttons = new List<Button>();
            while (reader.Read())
            {
                String databaseName = (string)reader["name"];
                if (databaseName != "master" && databaseName != "tempdb")
                {
                    Button newButton = new Button();
                    newButton.Size = button1.Size;
                    newButton.FlatStyle = button1.FlatStyle;
                    newButton.ForeColor = Color.White;
                    newButton.Text = databaseName;
                    if (buttons.Count < 1)
                        newButton.Location = new Point(0, 0);
                    else
                        newButton.Location = new Point(
                            buttons[buttons.Count - 1].Location.X,
                            buttons[buttons.Count - 1].Location.Y + newButton.Size.Height + 20);

                    newButton.Click += databaseSelect;
                    buttons.Add(newButton);
                    panel1.Controls.Add(newButton);
                }
            }
            pictureBox1.Visible = false;
            panel1.Visible = true;
            reader.Close();
        }

        private void databaseSelect(object sender, EventArgs e)
        {

            Button senderBtn = (Button)sender;
            panel2.AutoScroll = true;
            

            selectedDB = senderBtn.Text;

            SqlCommand selectdatabase = new SqlCommand("Select name from sys.tables;", conn);
            reader = selectdatabase.ExecuteReader();
            List<Button> buttons = new List<Button>();
            while (reader.Read())
            {
                String tableName = (string)reader["name"];
                Button newButton = new Button();
                newButton.Size = button1.Size;
                newButton.Size = new Size(panel2.Width - 20, button1.Height);
                newButton.FlatStyle = button1.FlatStyle;
                newButton.ForeColor = Color.Black;
                newButton.Text = tableName;
                if (buttons.Count < 1)
                    newButton.Location = new Point(0, 0);
                else
                    newButton.Location = new Point(
                        buttons[buttons.Count - 1].Location.X,
                        buttons[buttons.Count - 1].Location.Y + newButton.Size.Height);

                newButton.Click += tableSelect;
                buttons.Add(newButton);
                panel2.Controls.Add(newButton);
            }
            reader.Close();
            tabPage2.Enabled = true;
            tabPage5.Enabled = true;
            tabControl1.SelectTab(1);
        }

        private void tableSelect(object sender, EventArgs e)
        {
            Button senderBtn = (Button)sender;
            selectedTB = senderBtn.Text;

            button4.Visible = true;
            button6.Visible = true;
            dataGridView1.ReadOnly = false;

            dataGridView1.DataSource = bindingSource1;
            tries = 2;
            GetData("select * from " + selectedTB);
            //GetData(" Select * from sys.procedures");
            //GetData("table_group_A");


        }

        private void GetData(string selectCommand)
        {
            try
            {
                // Specify a connection string. Replace the given value with a 
                // valid connection string for a Northwind SQL Server sample
                // database accessible to your system.


                // Create a new data adapter based on the specified query.
                dataAdapter = new SqlDataAdapter(selectCommand, connectionString);

                // Create a command builder to generate SQL update, insert, and
                // delete commands based on selectCommand. These are used to
                // update the database.
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);

                // Populate a new data table and bind it to the BindingSource.
                DataTable table = new DataTable();
                table.Locale = System.Globalization.CultureInfo.InvariantCulture;
                dataAdapter.Fill(table);
                bindingSource1.DataSource = table;

                // Resize the DataGridView columns to fit the newly loaded content.
                dataGridView1.AutoResizeColumns(
                    DataGridViewAutoSizeColumnsMode.AllCellsExceptHeader);

                tabControl1.SelectTab(2);
                tabPage3.Enabled = true;
            }
            catch (SqlException ex)
            {
                if (tries > 0)
                {
                    tries--;
                    GetData(selectCommand);
                    
                }
                else if (ex.Message.Contains("parameter"))
                {
                    string UserAnswer = Microsoft.VisualBasic.Interaction.InputBox("need parameter! team_name", "team_name", "sample_team_name");
                    GetData(selectCommand + " \'" + UserAnswer + "\'");
                }
                else
                    MessageBox.Show("Error :D \n " + ex.Message);
            }

            //String connectionString =
            //    "Data Source=sql5028.mywindowshosting.com; " +
            // "Initial Catalog=DB_A12AC1_db94; " +
            // "User ID=DB_A12AC1_db94_admin; " +
            // "Password=db12345678";

            ////SqlDataAdapter dataAdapter = new SqlDataAdapter(selectCommand, connectionString); //c.con is the connection string

            ////SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
            ////DataSet ds = new DataSet();
            ////dataAdapter.Fill(ds);
            ////dataGridView1.ReadOnly = true;
            ////dataGridView1.DataSource = ds.Tables[0];

            //SqlConnection con = new SqlConnection(connectionString);


            //SqlCommand sqlCmd = new SqlCommand();
            //sqlCmd.Connection = con;
            //sqlCmd.CommandType = CommandType.Text;
            //sqlCmd.CommandText = "Select * from Players";
            //SqlDataAdapter sqlDataAdap = new SqlDataAdapter(sqlCmd);

            //DataTable dtRecord = new DataTable();
            //sqlDataAdap.Fill(dtRecord);
            //dataGridView2.DataSource = dtRecord;
            

        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            tabControl1.SelectTab(0);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            GetData(dataAdapter.SelectCommand.CommandText);
        }

        private void button4_Click(object sender, EventArgs e)
        {
            dataAdapter.Update((DataTable)bindingSource1.DataSource);
        }

        private void button5_Click(object sender, EventArgs e)
        {
            tabPage4.Enabled = true;
            Boolean done = false;
            int local_tries = 2;
            while (!done)
                try
                {
                    SqlCommand selectdatabase = new SqlCommand("Select name from sys.procedures;", conn);
                    reader = selectdatabase.ExecuteReader();
                    List<Button> buttons = new List<Button>();
                    while (reader.Read())
                    {
                        String tableName = (string)reader["name"];
                        Button newButton = new Button();
                        newButton.Size = button1.Size;
                        newButton.Size = new Size(panel4.Width - 20, button1.Height);
                        newButton.FlatStyle = button1.FlatStyle;
                        newButton.ForeColor = Color.Black;
                        newButton.Text = tableName;
                        if (buttons.Count < 1)
                            newButton.Location = new Point(0, 0);
                        else
                            newButton.Location = new Point(
                                buttons[buttons.Count - 1].Location.X,
                                buttons[buttons.Count - 1].Location.Y + newButton.Size.Height);

                        newButton.Click += procedureSelect;
                        buttons.Add(newButton);
                        panel4.Controls.Add(newButton);
                       
                    }
                    reader.Close();
                    tabControl1.SelectTab(3);
                    panel4.AutoScroll = true;
                    done = true;
                }
                catch (Exception ex)
                {
                    if (local_tries > 0)
                        local_tries--;
                    else
                    {
                        Console.WriteLine(ex.Message);
                        done = true;
                    }
                }

        }

        private void procedureSelect(object sender, EventArgs e)
        {
            Button senderBtn = (Button)sender;
            button4.Visible = false;
            button6.Visible = false;

            dataGridView1.DataSource = bindingSource1;
            tries = 2;
            string cmd = "exec " + senderBtn.Text;
            GetData(cmd);
        }

        private void button6_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow item in dataGridView1.SelectedRows)
            {
                dataGridView1.Rows.RemoveAt(item.Index);
            }
        }

        private void button7_Click(object sender, EventArgs e)
        {
            tabControl1.SelectTab(1);
        }

        private void button8_Click(object sender, EventArgs e)
        {
            tabControl1.SelectTab(4);
        }

        private void button9_Click(object sender, EventArgs e)
        {
            string query = textBox1.Text;
            if (query.Contains(";")){
                MessageBox.Show("1 query without \";\".");
            }
            else if (!query.ToLower().Contains("select"))
            {
                MessageBox.Show("You should have a select in your query!");
            }
            else
            {
                

                button4.Visible = false;
                button6.Visible = false;

                dataGridView1.DataSource = bindingSource1;
                dataGridView1.ReadOnly = true;
                tries = 1;
                GetData(textBox1.Text);

                
            }
        }

        private void button10_Click(object sender, EventArgs e)
        {

            tries = 2;
            while (tries > 0)
            {
                try
                {
                    SqlCommand command = new SqlCommand(textBox2.Text, new SqlConnection(connectionString));
                    command.Connection.Open();
                    int x = command.ExecuteNonQuery();
                    MessageBox.Show("Done " + x);
                    tries = 0;
                }
                catch (Exception ex)
                {
                    if (tries > 0)
                    {
                        tries--;
                    }
                    else
                    {
                        MessageBox.Show("ERROR:\n" + ex.Message);
                    }
                }
               
            }
        }
    }
}
