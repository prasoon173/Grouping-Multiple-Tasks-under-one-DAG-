from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.dummy_operator import DummyOperator
import datetime
from airflow.utils.dates import days_ago

default_dag_args = { 
    'owner' :'airflow',
    'start_date': days_ago(1), #setting start_date as yesterday here immediately starts the DAG when it is detected in GCS
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=5)
}

with DAG(
    'all_tasks_in_one_dag',
    schedule_interval=datetime.timedelta(days=1), #continue to run DAG once per day
    default_args=default_dag_args
)as dag:

    start = DummyOperator(
        task_id='start'
    )

    task_1 =BashOperator(
        task_id='op-1',
        bash_command=':',
        dag=dag
    )
    task_2=BashOperator(
        task_id='op-2',
        bash_command=':',
        dag=dag
    )
    some_other_task = DummyOperator(
        task_id='some-other-task'
    )
    task_3 = BashOperator(
        task_id='op-3',
        bash_command=':',
        dag=dag
    )
    task_4 = BashOperator(
        task_id='ope-4',
        bash_command=':',
        dag=dag
    )
    end=DummyOperator(
        task_id='end'
    )

    start>>[task_1,task_2]>>some_other_task>>[task_3,task_4]>>end
    
    
    
